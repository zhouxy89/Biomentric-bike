//
//  LocationManager.swift
//  BasicProject
//
//  Created by Manuel Lehé on 01.09.22.
//

import MapKit

class LocationManager: NSObject,ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var region = MKCoordinateRegion()
    @Published var heading = CLHeading()
    var locationHistory: [CLLocationCoordinate2D] = []
    
    private override init()
    {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = AppConfig.location.accuracy
        locationManager.distanceFilter = AppConfig.location.distanceFilter
        locationManager.headingFilter = AppConfig.location.headingFilter
        locationManager.activityType = AppConfig.location.activityType
        locationManager.requestAlwaysAuthorization()
        
        //Init Region
        region = MKCoordinateRegion(center: AppConfig.location.startPosition, span: AppConfig.location.span)
    }
    
    var statusString: String {
        guard let status = locationStatus else{
            return "unknown"
        }
        
        switch status {
        case .notDetermined:
            return "not determindes"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "authorized always"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .authorized:
            return "authorized"
        default:
            return "unknown"
        }
    }
    
    func getHistoryPolyline() -> MKPolyline{
        return MKPolyline(coordinates: &locationHistory, count: locationHistory.count)
    }
    func startTracking()
    {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func stopTracking()
    {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        locationStatus = status
        //print(#function,statusString)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else {return}
        
        lastLocation = location
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            span: AppConfig.location.span)
        self.locationHistory.append(location.coordinate)
        //print(#function, location)
        print("new location set \(region.center)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
    }
}
