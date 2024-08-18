import Foundation
import Network

struct ConnectionData {
    let connection: NWConnection
    let id: UUID
    var clientData: ClientData
}

struct ClientData {
    var brakeData: Int = 0
    var pedalDataR: Int = 0
    var pedalDataL: Float = 0.0
    var latestCadence: String = "NaN"
}


class LogItemServer: ObservableObject {
    private var cadence: String = "NaN"
    
    @Published var latestBrakeData: Int = 0
    @Published var latestPedalDataR: Int = 0
    @Published var latestPedalDataL: Float = 0.0
    @Published var viewCadence: String = "NaN"
    var latestCadence: String {
        set {
            DispatchQueue.main.async { [weak self] in
                self?.cadence = newValue
            }
        }
        get {
            let currentCadence = cadence
            DispatchQueue.main.async { [weak self] in
                self?.cadence = "NaN" // Reset to "NaN" after being accessed
            }
            return currentCadence
        }
    }
    
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
                let dataComponents = dataString.split(separator: "=").map(String.init)
                if dataComponents.count == 2 {
                    let key = dataComponents[0]
                    let stringValue = dataComponents[1]
                    if let floatValue = Float(stringValue) { // Safely converting string to float
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            var connectionData = self.connections[index]
                    
                            switch key {
                            case "brakeData":
                                connectionData.clientData.brakeData = Int(floatValue)
                                self.latestBrakeData = Int(floatValue) // Update shared property
                            case "pedalDataR":
                                connectionData.clientData.pedalDataR = Int(floatValue)
                                self.latestPedalDataR = Int(floatValue) // Update shared property
                            case "pedalDataL":
                                connectionData.clientData.pedalDataL = floatValue
                                self.latestPedalDataL = floatValue // Update shared property
                            case "cadence":
                                connectionData.clientData.latestCadence = stringValue
                                self.latestCadence = stringValue
                                self.viewCadence = stringValue
                            default:
                                break
                            }
                            self.connections[index] = connectionData
                        }
                    }
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
