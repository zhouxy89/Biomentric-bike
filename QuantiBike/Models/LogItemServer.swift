import Foundation
import Network

struct ConnectionData {
    let connection: NWConnection
    let id: UUID
}

class LogItemServer: ObservableObject {
    private var listener: NWListener
    private var connections: [ConnectionData] = []
    var logManagers: [String: LogManager] = [:]  // Store separate LogManager per board

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
        let connectionData = ConnectionData(connection: connection, id: UUID())
        connections.append(connectionData)
        processConnection(connectionData)
    }

    private func processConnection(_ connectionData: ConnectionData) {
        connectionData.connection.start(queue: .main)
        connectionData.connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { [weak self] (data, _, isComplete, error) in
            guard let self = self else { return }

            if let data = data, !data.isEmpty {
                self.processData(data)
            }

            if isComplete || error != nil {
                connectionData.connection.cancel()
                self.connections.removeAll { $0.id == connectionData.id }
            }
        }
    }

    private func processData(_ data: Data) {
        if let dataString = String(data: data, encoding: .utf8) {
            let pairs = dataString.split(separator: "&").map { String($0) }
            var parsedData: [String: String] = [:]

            for pair in pairs {
                let parts = pair.split(separator: "=", maxSplits: 1).map { String($0) }
                if parts.count == 2 {
                    parsedData[parts[0]] = parts[1]
                }
            }

            guard let boardID = parsedData["board"] else {
                print("⚠️ No board ID in data!")
                return
            }

            if logManagers[boardID] == nil {
                let newManager = LogManager()
                newManager.setSubjectId(subjectId: boardID)
                newManager.setMode(mode: "field")
                newManager.setStartTime(startTime: Date())
                logManagers[boardID] = newManager
                print("✅ Created new LogManager for \(boardID)")
            }

            if let manager = logManagers[boardID] {
                let runtime = Date().timeIntervalSinceReferenceDate
                let fsr1 = Int(parsedData["fsr1"] ?? "0") ?? 0
                let fsr2 = Int(parsedData["fsr2"] ?? "0") ?? 0
                let fsr3 = Int(parsedData["fsr3"] ?? "0") ?? 0
                let fsr4 = Int(parsedData["fsr4"] ?? "0") ?? 0

                manager.triggerUpdate(runtime: runtime, fsr1: fsr1, fsr2: fsr2, fsr3: fsr3, fsr4: fsr4)
            }
        }
    }

    func stop() {
        listener.cancel()
        connections.forEach { $0.connection.cancel() }
        connections.removeAll()
    }
}
