//
//  LogItemServer.swift
//  QuantiBike
//
//  Created by Mohamed Mahdi on 2024-04-07.
//

import Foundation
import Network
import CoreMotion
import CoreLocation

class LogItemServer : ObservableObject {
    @Published var latestBrakeData: Float = 0.0
    @Published var latestPedalDataR: Float = 0.0
    @Published var latestPedalDataL: Float = 0.0
    
    private var listener: NWListener
    private var connectedClients: [NWConnection] = []

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
            if let data = data, !data.isEmpty {
                let dataString = String(data: data, encoding: .utf8)
                let dataComponents = dataString?.split(separator: "-").map(String.init)
                if let components = dataComponents, components.count == 3,
                   let brakeData = Float(components[0]),
                   let pedalDataR = Float(components[1]),
                   let pedalDataL = Float(components[2]) {
                    DispatchQueue.main.async {
                                  self.latestBrakeData = brakeData
                                  self.latestPedalDataR = pedalDataR
                                  self.latestPedalDataL = pedalDataL
                              }
                }
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
