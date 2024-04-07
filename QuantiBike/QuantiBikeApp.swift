//
//  BasicProjectApp.swift
//  BasicProject
//
//  Created by Manuel Lehé on 10.08.22.
//

import SwiftUI

@main
struct QuantiBikeApp: App {
    init(){
        LocationManager.shared.startTracking()
        do {
            print("Received brake data:")
            let server = try LogItemServer(port: 12345)
            server.start()
            print(server)
            server.onBrakeDataReceived = { brakeData in
                print("Received brake data: \(brakeData)")
                // Update LogItem's brakeData or handle as needed
            }
        } catch {
            // Handle the error appropriately
            print("An error occurred: \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

