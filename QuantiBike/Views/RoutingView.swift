//  MapView.swift
//  QuantiBike
//
//  Updated to reflect new 4-FSR sensor structure

import MapKit
import SwiftUI
import AVFoundation

struct RoutingView: View {
    @EnvironmentObject var logItemServer: LogItemServer
    @State var logManager = LogManager()
    @Binding var subjectId: String
    @Binding var subjectSet: Bool
    @State var currentAnnouncement: RouteAnnouncement?

    var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var startTime: Date = Date()
    @State var runtime: Float64 = 0.0

    var body: some View {
        VStack{
            MapView(announcement: $currentAnnouncement)
                .ignoresSafeArea(.all)
                .overlay(alignment: .topLeading){
                    HStack(alignment: .top){
                        if(currentAnnouncement != nil){
                            VStack{
                                HStack{
                                    Image(systemName: currentAnnouncement!.getIcon())
                                        .fontWeight(.bold)
                                        .font(.custom("Arrow", size: 65, relativeTo: .largeTitle))
                                    Text("\(currentAnnouncement!.distance)m").font(.title).fontWeight(.bold)
                                }.padding(10)
                                Text(currentAnnouncement!.getText()).font(.headline).padding(10)
                            }.background(Color(.black).cornerRadius(10))
                        }
                    }.padding(10)
                }
                .overlay(alignment: .bottomTrailing){
                    HStack(alignment: .bottom){
                        VStack{
                            if(logManager.headPhoneMotionManager.deviceMotion != nil){
                                Image(systemName: "airpodspro")
                                    .foregroundColor(Color(.systemGreen)).padding(10)
                            }else{
                                Image(systemName: "airpodspro")
                                    .foregroundColor(Color(.systemRed)).padding(10)
                            }
                            HStack{
                                Text("\(String(format: "%03d", Int(runtime)))")
                                    .onReceive(timer) { _ in
                                        runtime = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
                                        let fsr1: Int = logItemServer.latestFSR1
                                        let fsr2: Int = logItemServer.latestFSR2
                                        let fsr3: Int = logItemServer.latestFSR3
                                        let fsr4: Int = logItemServer.latestFSR4

                                        print("FSR1: \(fsr1), FSR2: \(fsr2), FSR3: \(fsr3), FSR4: \(fsr4)")

                                        logManager.triggerUpdate(runtime: runtime, fsr1: fsr1, fsr2: fsr2, fsr3: fsr3, fsr4: fsr4)
                                    }
                            }
                            Button("Finish",role:.destructive,action:{
                                logManager.saveCSV()
                                subjectSet = false
                            }).buttonStyle(.borderedProminent).cornerRadius(10).padding(10)
                        }.background(Color(.black).cornerRadius(10))
                    }.padding(10)
            }.onAppear(perform: {
                preventSleep()
                logManager.setSubjectId(subjectId: subjectId)
                logManager.setStartTime(startTime: startTime)
                logManager.setMode(mode: "map")
            }).onDisappear(perform: {
                logManager.stopUpdates()
            })
        }
    }
}

func preventSleep(){
    if(UIApplication.shared.isIdleTimerDisabled == false){
        UIApplication.shared.isIdleTimerDisabled = true
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        RoutingView(subjectId: .constant("test"), subjectSet: .constant(true), currentAnnouncement: RouteAnnouncement(action: "left", location: CLLocation(), updateMap: false))
    }
}
