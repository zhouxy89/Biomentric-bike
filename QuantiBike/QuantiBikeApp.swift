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
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
