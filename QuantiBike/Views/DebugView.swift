//
//  DebugView.swift
//  QuantiBike
//
//  Created by Manuel Lehé on 08.09.22.
//

import SwiftUI
import CoreLocation

struct DebugView: View {
    @Binding var subjectId: String
    @Binding var debug: Bool
    @StateObject var logManager = LogManager()
    @EnvironmentObject var logItemServer: LogItemServer
    
    var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var startTime = Date()
    @State var runtime = 0.0
    
    var body: some View {
        HStack{
            VStack{
                HStack{
                    Image(systemName: "bicycle")
                    Text("QuantiBike").font(.largeTitle)
                }
                Spacer()
                HStack{
                    Image(systemName: "person.circle")
                    Text("Subject ID " + subjectId).font(.subheadline)
                }
                List{
                    HStack{
                        Image(systemName: "clock")
                        Text(stringFromTime(interval: runtime)).onReceive(timer) { _ in
                                runtime = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
                                let brakeData: Int = logItemServer.latestBrakeData
                                let cadence: String = logItemServer.latestCadence
                                let pedalDataR: Int = logItemServer.latestPedalDataR
                                let pedalDataL: Float = logItemServer.latestPedalDataL
                                logManager.triggerUpdate(runtime: runtime, brakeData: brakeData, cadence: cadence, pedalDataR: pedalDataR, pedalDataL: pedalDataL)
                        }.font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "brake")
                        //Bike Brake Data
                       Text("Brake: \(logItemServer.latestBrakeData)").font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "PedalWeight")
                        //Bike Brake Data
                        Text("Right: \(logItemServer.latestPedalDataR), Left: \(logItemServer.latestPedalDataL)").font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "cadence")
                        //Bike Brake Data
                       Text("Cadence: \(logItemServer.viewCadence)").font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "iphone")
                        //iPhone Rotation Rate. Docs see CMGyroData
                        if logManager.motionManager.deviceMotion != nil{
                            Text("\(logManager.motionManager.deviceMotion!)").font(.subheadline)
                        }else{
                            Text("No Gyro Data present").font(.subheadline)
                        }
                    }
                    HStack{
                        Image(systemName: "speedometer")
                        //iPhone Rotation Rate. Docs see CMGyroData
                        if logManager.motionManager.accelerometerData != nil{
                            Text("\(logManager.motionManager.accelerometerData!)").font(.subheadline)
                        }else{
                            Text("No Acc Data present").font(.subheadline)
                        }
                    }
                    HStack{
                        Image(systemName: "safari")
                        //iPhone Rotation Rate. Docs see CMGyroData
                        Text("Longitude: \(logManager.getLongitude()), Latitude: \(logManager.getLatitude()), Altitude: \(logManager.getAltitude())").font(.subheadline)
                    }
                }
                Spacer()
                Button("Save CSV",role:.destructive,action:{
                    logManager.saveCSV()
                    debug = false
                }).buttonStyle(.borderedProminent)
            }
        }.onAppear(perform: {
            //Alway on Display
            preventSleep()
            logManager.setSubjectId(subjectId: subjectId)
            logManager.setMode(mode: "debug")
            logManager.setStartTime(startTime: startTime)
        }).onDisappear(perform: {
            logManager.stopUpdates()
        })
    }
    func logHack(val:Any,label:String?){
        if label != nil{
            var _ = print("\(label!): \(val)")
        }else{
            var _ = print(val)
        }
    }
    func stringFromTime(interval: TimeInterval) -> String {
        let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: interval)! + ".\(ms)"
    }
    func preventSleep(){
        if(UIApplication.shared.isIdleTimerDisabled == false){
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}
