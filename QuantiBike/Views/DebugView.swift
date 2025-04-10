//  DebugView.swift
//  QuantiBike
//
//  Updated to reflect new 4-FSR sensor structure

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
                            let fsr1: Int = logItemServer.latestFSR1
                            let fsr2: Int = logItemServer.latestFSR2
                            let fsr3: Int = logItemServer.latestFSR3
                            let fsr4: Int = logItemServer.latestFSR4
                            logManager.triggerUpdate(runtime: runtime, fsr1: fsr1, fsr2: fsr2, fsr3: fsr3, fsr4: fsr4)
                        }.font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "1.circle")
                        Text("FSR1: \(logItemServer.latestFSR1)").font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "2.circle")
                        Text("FSR2: \(logItemServer.latestFSR2)").font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "3.circle")
                        Text("FSR3: \(logItemServer.latestFSR3)").font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "4.circle")
                        Text("FSR4: \(logItemServer.latestFSR4)").font(.subheadline)
                    }
                    HStack{
                        Image(systemName: "iphone")
                        if logManager.motionManager.deviceMotion != nil{
                            Text("\(logManager.motionManager.deviceMotion!)").font(.subheadline)
                        }else{
                            Text("No Gyro Data present").font(.subheadline)
                        }
                    }
                    HStack{
                        Image(systemName: "speedometer")
                        if logManager.motionManager.accelerometerData != nil{
                            Text("\(logManager.motionManager.accelerometerData!)").font(.subheadline)
                        }else{
                            Text("No Acc Data present").font(.subheadline)
                        }
                    }
                    HStack{
                        Image(systemName: "safari")
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
