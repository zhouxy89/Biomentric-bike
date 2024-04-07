import Foundation
import Network
import CoreMotion
import CoreLocation

class LogItemServer {
    private var listener: NWListener
    private var connectedClients: [NWConnection] = []
    var onBrakeDataReceived: ((Float) -> Void)?

    init(port: NWEndpoint.Port) throws {
        listener = try NWListener(using: .tcp, on: port)
    }

    func start() {
        listener.stateUpdateHandler = self.handleStateChange(state:)
        listener.newConnectionHandler = self.handleNewConnection(connection:)
        listener.start(queue: .main)
    }

    private func handleStateChange(state: NWListener.State) {
        switch state {
        case .ready:
            print("Server is ready.")
        case .failed(let error):
            print("Server failed with error: \(error)")
        default:
            break
        }
    }

    private func handleNewConnection(connection: NWConnection) {
        connection.start(queue: .main)
        connectedClients.append(connection)

        connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty, let brakeDataString = String(data: data, encoding: .utf8), let brakeData = Float(brakeDataString) {
                self.onBrakeDataReceived?(brakeData)
            }
            if isComplete || error != nil {
                connection.cancel()
                self.connectedClients.removeAll(where: { $0 === connection })
            }
        }
    }

    func stop() {
        listener.cancel()
        for client in connectedClients {
            client.cancel()
        }
        connectedClients.removeAll()
    }
}