//  LogManager.swift
//  QuantiBike
//
//  Created by Manuel Lehé on 08.09.22.
//

import Foundation
import CoreMotion
import UIKit
import CoreLocation
import MapKit

class LogManager: NSObject, ObservableObject {
    private var csvData: [LogItem] = []
    @Published var motionManager = CMMotionManager()
    @Published var headPhoneMotionManager = CMHeadphoneMotionManager()
    private var subjectId: String = ""
    private var startTime: Date = Date()
    private var mode: String = "not_defined"
    
    @Published var runtime = 0.0
    var latitude: String {
        return "\(LocationManager.shared.lastLocation?.coordinate.latitude ?? 0)"
    }
    var longitude: String{
        "\(LocationManager.shared.lastLocation?.coordinate.longitude ?? 0)"
    }
    var userAltitude: String{
        return "\(LocationManager.shared.lastLocation?.altitude ?? 0)"
    }
    
    
    override init() {
        super.init()
        //Track Battery Levels
        if(UIDevice.current.isBatteryMonitoringEnabled == false){
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
        //MARK: Start Data Updates
        //Phone Data
        if motionManager.isAccelerometerAvailable{
            motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        }
        //HeadphoneData
        if headPhoneMotionManager.isDeviceMotionAvailable{
            headPhoneMotionManager.startDeviceMotionUpdates()
        }
        if motionManager.isGyroAvailable{
            motionManager.startGyroUpdates()
        }
        if motionManager.isAccelerometerAvailable{
            motionManager.startAccelerometerUpdates()
        }
    }
    
    private func getCsvJson(logArr: [LogItem]){
        var jsonString: String {
            var str = "{"
            for item in logArr{
                str.append(contentsOf: item.json)
                str.append(contentsOf: ",")
            }
            str.append(contentsOf: "}")
            return str
        }
    }
    
    private func dateAsString(date: Date) -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HHmmss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    //Timer handler
    func triggerUpdate(runtime: TimeInterval, brakeData: Int, cadence: String, pedalDataR: Int, pedalDataL: Float) {
        csvData.append(LogItem(
            timestamp: runtime,
            phoneBattery: UIDevice.current.batteryLevel,
            brakeData: brakeData,
            cadence: cadence,
            pedalDataR: pedalDataR,
            pedalDataL: pedalDataL,
            phoneAcceleration: motionManager.accelerometerData,
            phoneMotionData: motionManager.deviceMotion,
            locationData: LocationManager.shared.lastLocation
        ))
    }

    func stopUpdates(){
        motionManager.stopGyroUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        headPhoneMotionManager.stopDeviceMotionUpdates()
    }
    func setSubjectId(subjectId: String){
        self.subjectId = subjectId
    }
    func setMode(mode: String){
        self.mode = mode
    }
    func setStartTime(startTime: Date){
        self.startTime = startTime
    }
    func getLongitude() -> String {
        return self.longitude
    }
    func getLatitude() -> String {
        return self.latitude
    }
    func getAltitude() -> String {
        return self.userAltitude
    }
    func getSingleInfos() -> String {
        var infos = "{\"infos\":{"
        infos.append(contentsOf: "\"subject\":\"\(subjectId)\",")
        infos.append(contentsOf: "\"mode\":\"\(mode)\",")
        infos.append(contentsOf: "\"starttime\":\"\(dateAsString(date: startTime))\"")
        infos.append(contentsOf: "},")
        return infos
    }
    //MARK: Save SCV
    func saveCSV(){
        let fileManager = FileManager.default
        do{
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask,appropriateFor: nil, create: false)
            let fileUrl = path.appendingPathComponent("\(dateAsString(date: startTime))-logfile-subject-\(self.subjectId).json")
            
            for (index,element) in csvData.enumerated() {
                //If file exists, append at the end
                if let fileUpdate = try? FileHandle(forUpdating: fileUrl){
                    if index != csvData.endIndex{
                        
                        fileUpdate.seekToEndOfFile()
                        try fileUpdate.write(contentsOf: ",".data(using: .utf8)!)
                    }
                    fileUpdate.seekToEndOfFile()
                    try fileUpdate.write(contentsOf: element.json.data(using: .utf8)!)
                    fileUpdate.closeFile()
                //if file doesn´t exist, create the file
                }else{
                    var firstJson = getSingleInfos()
                    firstJson.append("\"timestamps\":[" + element.json)
                    try firstJson.write(to: fileUrl, atomically: true, encoding: .utf8)
                }
            }
            if let fileUpdate = try? FileHandle(forUpdating: fileUrl){
                fileUpdate.seekToEndOfFile()
                try fileUpdate.write(contentsOf: "]}".data(using: .utf8)!)
            }
            print("csv created!")
        }catch{
            print("error while creating log")
        }
    }
}

