import Foundation
import Network

struct ConnectionData {
    let connection: NWConnection
    let id: UUID
    var clientData: ClientData
}

struct ClientData {
    var fsr1: Int = 0
    var fsr2: Int = 0
    var fsr3: Int = 0
    var fsr4: Int = 0
}

class LogItemServer: ObservableObject {
    
    @Published var latestFSR1: Int = 0
    @Published var latestFSR2: Int = 0
    @Published var latestFSR3: Int = 0
    @Published var latestFSR4: Int = 0

    private var listener: NWListener
    private var connections: [ConnectionData] = []

    init(port: NWEndpoint.Port) throws {
        listener = try NWListener(using: .tcp, on: port)
    }

    func start() {
        listener.stateUpdateHandler = handleStateChange(state:)
        listener.newConnectionHandler = handleNewConnection(connection:)
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
        connections.forEach { $0.connection.cancel() }
        connections.removeAll()
        let connectionData = ConnectionData(connection: connection, id: UUID(), clientData: ClientData())
        connections.append(connectionData)
        processConnection(connectionData)
    }

    private func processConnection(_ connectionData: ConnectionData) {
        connectionData.connection.start(queue: .main)
        connectionData.connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { [weak self] (data, _, isComplete, error) in
            guard let self = self else { return }

            if let data = data, !data.isEmpty {
                self.processData(data, for: connectionData.id)
            }

            if isComplete || error != nil {
                connectionData.connection.cancel()
                self.connections.removeAll { $0.id == connectionData.id }
            }
        }
    }

    private func processData(_ data: Data, for id: UUID) {
        if let index = connections.firstIndex(where: { $0.id == id }) {
            if let dataString = String(data: data, encoding: .utf8) {
                let keyValuePairs = dataString.split(separator: "&")

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    var connectionData = self.connections[index]

                    for pair in keyValuePairs {
                        let components = pair.split(separator: "=").map(String.init)
                        if components.count == 2 {
                            let key = components[0]
                            let valueString = components[1]
                            if let intValue = Int(valueString) {
                                switch key {
                                case "fsr1":
                                    connectionData.clientData.fsr1 = intValue
                                    self.latestFSR1 = intValue
                                case "fsr2":
                                    connectionData.clientData.fsr2 = intValue
                                    self.latestFSR2 = intValue
                                case "fsr3":
                                    connectionData.clientData.fsr3 = intValue
                                    self.latestFSR3 = intValue
                                case "fsr4":
                                    connectionData.clientData.fsr4 = intValue
                                    self.latestFSR4 = intValue
                                default:
                                    break
                                }
                            }
                        }
                    }
                    self.connections[index] = connectionData
                }
            }
        }
    }

    func stop() {
        listener.cancel()
        connections.forEach { $0.connection.cancel() }
        connections.removeAll()
    }
}
