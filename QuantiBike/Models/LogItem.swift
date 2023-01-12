//
//  LogItem.swift
//  BasicProject
//
//  Created by Manuel Lehé on 18.08.22.
//

import Foundation
import CoreMotion
import CoreLocation

struct LogItem{
    let timestamp : TimeInterval
    let phoneAcceleration : CMAccelerometerData?
    let airpodMotionData : CMDeviceMotion?
    let phoneMotionData : CMDeviceMotion?
    let phoneBattery: Float
    let locationData: CLLocation?
    
    init(timestamp : TimeInterval,phoneBattery: Float, phoneAcceleration: CMAccelerometerData? = nil, airpodRotationRate: CMDeviceMotion? = nil, phoneRotationRate: CMDeviceMotion? = nil,locationData: CLLocation?){
        self.timestamp = timestamp
        self.phoneAcceleration = phoneAcceleration
        self.airpodMotionData = airpodRotationRate
        self.phoneMotionData = phoneRotationRate
        self.phoneBattery = phoneBattery
        self.locationData = locationData
        //print("Got logItem: \(dictionary)")
    }
    var dictionary: [String:Any]{
                return [
                "timestamp": String(timestamp),
                "phoneBattery": String(phoneBattery),
                "phoneAcceleration" : preparePhoneAcc(),
                "phoneMotionData" : prepareMotionData(motionData: phoneMotionData),
                "airpodMotionData" : prepareMotionData(motionData: airpodMotionData),
                "locationData": prepareLocationData(locationData: locationData)
            ]
    }
    var data: Data {return (try? JSONSerialization.data(withJSONObject: dictionary)) ?? Data() }
    var json: String { return String(data: data,encoding: .utf8) ?? String() }
    
    func preparePhoneAcc() -> [String:String]{
        return [
            "x":phoneAcceleration?.acceleration.x.description ?? "",
            "y":phoneAcceleration?.acceleration.y.description ?? "",
            "z":phoneAcceleration?.acceleration.z.description ?? "",
            "timestamp":phoneAcceleration?.timestamp.description ?? ""
        ]
    }
    func prepareMotionData(motionData: CMDeviceMotion?) -> [String:Any]{
        var motionArr : [String:Any] = [String:Any]()
        motionArr["quaternion"] = [
            "x": motionData?.attitude.quaternion.x.description ?? "",
            "y": motionData?.attitude.quaternion.y.description ?? "",
            "z": motionData?.attitude.quaternion.z.description ?? "",
            "w": motionData?.attitude.quaternion.w.description ?? ""
        ]
        motionArr["pitch"] = motionData?.attitude.pitch.description ?? ""
        motionArr["yaw"] = motionData?.attitude.yaw.description ?? ""
        motionArr["roll"] = motionData?.attitude.roll.description ?? ""
        motionArr["timestamp"] = motionData?.timestamp.description ?? ""
        motionArr["rotationMatrix"] = prepareRotationMatrix(motionData: motionData)
        motionArr["userAccel"] = [
            "x": motionData?.userAcceleration.x.description ?? "",
            "y": motionData?.userAcceleration.y.description ?? "",
            "z": motionData?.userAcceleration.z.description ?? ""
        ]
        motionArr["rotationRate"] = [
            "x": motionData?.rotationRate.x.description ?? "",
            "y": motionData?.rotationRate.y.description ?? "",
            "z": motionData?.rotationRate.z.description ?? ""
        ]
        motionArr["magneticField"] = [
            "x": motionData?.magneticField.field.x.description ?? "",
            "y": motionData?.magneticField.field.y.description ?? "",
            "z": motionData?.magneticField.field.z.description ?? "",
            "accuracy": motionData?.magneticField.accuracy.rawValue.description ?? ""
        ]
        return motionArr
    }
    func prepareLocationData(locationData: CLLocation?) -> [String:String]{
        return [
            "longitude":locationData?.coordinate.longitude.description ?? "",
            "latitude":locationData?.coordinate.latitude.description ?? "",
            "altitude":locationData?.altitude.description ?? "",
            "velocity": locationData?.speed.description ?? "",
            "timestamp": locationData?.timestamp.description ?? ""
        ]
    }
    func prepareRotationMatrix(motionData: CMDeviceMotion?) -> [String:String]{
        
        return [
            "m1.1": motionData?.attitude.rotationMatrix.m11.description ?? "",
            "m1.2": motionData?.attitude.rotationMatrix.m12.description ?? "",
            "m1.3": motionData?.attitude.rotationMatrix.m13.description ?? "",
            "m2.1": motionData?.attitude.rotationMatrix.m21.description ?? "",
            "m2.2": motionData?.attitude.rotationMatrix.m22.description ?? "",
            "m2.3": motionData?.attitude.rotationMatrix.m23.description ?? "",
            "m3.1": motionData?.attitude.rotationMatrix.m31.description ?? "",
            "m3.2": motionData?.attitude.rotationMatrix.m32.description ?? "",
            "m3.3": motionData?.attitude.rotationMatrix.m33.description ?? ""
        ]
    }
}
