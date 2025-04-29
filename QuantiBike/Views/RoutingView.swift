//  MapView.swift
//  QuantiBike
//
//  Updated to reflect new 4-FSR sensor structure

import MapKit
import SwiftUI
import AVFoundation


struct RoutingView: View {
    @EnvironmentObject var logItemServer: LogItemServer
    @Binding var subjectId: String
    @Binding var subjectSet: Bool
    @State var currentAnnouncement: RouteAnnouncement?

    var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var startTime = Date()
    @State var runtime: TimeInterval = 0.0

    var body: some View {
        VStack {
            MapView(announcement: $currentAnnouncement)
                .ignoresSafeArea()
                .overlay(alignment: .bottomTrailing) {
                    VStack {
                        ForEach(Array(logItemServer.logManagers.keys), id: \.\self) { boardID in
                            if let manager = logItemServer.logManagers[boardID] {
                                VStack(alignment: .leading) {
                                    Text("Board: \(boardID)")
                                    Text("FSR1: \(manager.latestFSR1)")
                                    Text("FSR2: \(manager.latestFSR2)")
                                    Text("FSR3: \(manager.latestFSR3)")
                                    Text("FSR4: \(manager.latestFSR4)")
                                }
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            }
                        }

                        Button("Finish", role: .destructive) {
                            for (_, manager) in logItemServer.logManagers {
                                manager.saveCSV()
                            }
                            subjectSet = false
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
        }
        .onAppear {
            preventSleep()
            startTime = Date()
        }
        .onReceive(timer) { _ in
            runtime = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            for (_, manager) in logItemServer.logManagers {
                let fsr1 = manager.latestFSR1
                let fsr2 = manager.latestFSR2
                let fsr3 = manager.latestFSR3
                let fsr4 = manager.latestFSR4
                manager.triggerUpdate(runtime: runtime, fsr1: fsr1, fsr2: fsr2, fsr3: fsr3, fsr4: fsr4)
            }
        }
    }

    func preventSleep() {
        if UIApplication.shared.isIdleTimerDisabled == false {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}

struct RoutingView_Previews: PreviewProvider {
    static var previews: some View {
        RoutingView(subjectId: .constant("test"), subjectSet: .constant(true))
            .environmentObject(try! LogItemServer(port: 12345))
    }
}

