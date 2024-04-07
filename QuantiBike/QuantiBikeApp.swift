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
        let server = LogItemServer(port: 12345)
        server.onBrakeDataReceived = { brakeData in
            print("Received brake data: \(brakeData)")
            // Update LogItem's brakeData or handle as needed
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
