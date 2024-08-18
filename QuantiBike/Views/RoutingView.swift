//
//  MapView.swift
//  QuantiBike
//
//  Created by Manuel Lehé on 08.09.22.
//
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
                                //Image(systemName: "clock")
                                Text("\(String(format: "%03d", Int(runtime)))")
                                    .onReceive(timer) { _ in
                                            runtime = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
                                            let brakeData: Int = logItemServer.latestBrakeData
                                            let cadence: String = logItemServer.latestCadence
                                            let pedalDataR: Int = logItemServer.latestPedalDataR
                                            let pedalDataL: Float = logItemServer.latestPedalDataL
                                            print("Brake Data: \(brakeData), Pedal Data R: \(pedalDataR), Pedal Data L: \(pedalDataL)")

                                            logManager.triggerUpdate(runtime: runtime, brakeData: brakeData, cadence: cadence, pedalDataR: pedalDataR, pedalDataL: pedalDataL)
                                    }
                            }
                            Button("Finish",role:.destructive,action:{
                                logManager.saveCSV()
                                subjectSet = false
                            }).buttonStyle(.borderedProminent).cornerRadius(10).padding(10)
                        }.background(Color(.black).cornerRadius(10))
                    }.padding(10)
            }.onAppear(perform: {
                //Alway on Display
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
        RoutingView(subjectId: .constant("test"), subjectSet: .constant(true),currentAnnouncement: RouteAnnouncement(action: "left", location: CLLocation(),updateMap: false))
    }
}
