import Foundation
import CoreMotion
import CoreLocation

struct LogItem {
    let timestamp: TimeInterval
    let phoneAcceleration: CMAccelerometerData?
    let phoneMotionData: CMDeviceMotion?
    let phoneBattery: Float
    let fsr1: Int
    let fsr2: Int
    let fsr3: Int
    let fsr4: Int
    let locationData: CLLocation?

    init(timestamp: TimeInterval,
         phoneBattery: Float,
         fsr1: Int,
         fsr2: Int,
         fsr3: Int,
         fsr4: Int,
         phoneAcceleration: CMAccelerometerData? = nil,
         phoneMotionData: CMDeviceMotion? = nil,
         locationData: CLLocation?) {
        
        self.timestamp = timestamp
        self.phoneAcceleration = phoneAcceleration
        self.phoneMotionData = phoneMotionData
        self.phoneBattery = phoneBattery
        self.fsr1 = fsr1
        self.fsr2 = fsr2
        self.fsr3 = fsr3
        self.fsr4 = fsr4
        self.locationData = locationData
    }
    
    var dictionary: [String: Any] {
        var result: [String: Any] = [
            "timestamp": String(timestamp),
            "phoneBattery": String(phoneBattery),
            "fsr1": fsr1,
            "fsr2": fsr2,
            "fsr3": fsr3,
            "fsr4": fsr4,
            "acceleration": preparePhoneAcc(),
            "locationData": prepareLocationData(locationData: locationData),
            "unixTimeStamp": String(Date().timeIntervalSince1970)
        ]

        // Add motion data
        let motionData = prepareMotionData(motionData: phoneMotionData)
        for (key, value) in motionData {
            result[key] = value
        }

        return result
    }

    var data: Data {
        return (try? JSONSerialization.data(withJSONObject: dictionary)) ?? Data()
    }

    var json: String {
        return String(data: data, encoding: .utf8) ?? ""
    }

    func preparePhoneAcc() -> [String: String] {
        return [
            "x": phoneAcceleration?.acceleration.x.description ?? "",
            "y": phoneAcceleration?.acceleration.y.description ?? "",
            "z": phoneAcceleration?.acceleration.z.description ?? "",
            "timestamp": phoneAcceleration?.timestamp.description ?? ""
        ]
    }

    func prepareMotionData(motionData: CMDeviceMotion?) -> [String: Any] {
        var motionArr: [String: Any] = [:]
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

    func prepareLocationData(locationData: CLLocation?) -> [String: String] {
        return [
            "longitude": locationData?.coordinate.longitude.description ?? "",
            "latitude": locationData?.coordinate.latitude.description ?? "",
            "altitude": locationData?.altitude.description ?? "",
            "velocity": locationData?.speed.description ?? "",
            "timestamp": locationData?.timestamp.description ?? ""
        ]
    }

    func prepareRotationMatrix(motionData: CMDeviceMotion?) -> [String: String] {
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
