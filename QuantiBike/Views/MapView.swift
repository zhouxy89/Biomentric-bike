//
//  RouteView.swift
//  QuantiBike
//
//  Created by Manuel Lehé on 14.09.22.
//

import MapKit
import SwiftUI
import UIKit

//MARK: MapView
struct MapView: UIViewRepresentable {
    
    @Binding var currentAnnouncement: RouteAnnouncement?
    
    let locationManager: CLLocationManager = LocationManager.shared.locationManager
    let announcementHandler: AnnouncementHandler = AnnouncementHandler()
    
    private var lastLocation: CLLocation = CLLocation()
    init(announcement : Binding<RouteAnnouncement?>){
        lastLocation = CLLocation()
        self._currentAnnouncement = announcement
    }
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(for: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        addRoute(to: view,secondPart: false)
        configureView(view, context: context)
        return view
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        configureView(view, context: context)
    }
    
    private func configureView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>){
        
        mapView.isZoomEnabled = AppConfig.map.zoomEnables
        mapView.cameraZoomRange = AppConfig.map.zoomLevel
        mapView.isScrollEnabled = AppConfig.map.scrollEnabled
        mapView.isRotateEnabled = AppConfig.map.rotateEnabled
        mapView.showsUserLocation = AppConfig.map.showUserLocation
        mapView.userTrackingMode = AppConfig.map.userTrackingMode
        mapView.tintAdjustmentMode = AppConfig.map.tintAdjustMode
        mapView.tintColor = AppConfig.map.tintColor
        mapView.pointOfInterestFilter = AppConfig.map.poiFilter
    }
    //MARK: Map Coordinator
    public class Coordinator: NSObject, MKMapViewDelegate {
        private let context: MapView
        
        init(for context : MapView) {
            self.context = context
            super.init()
        }
        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            return getCustomRouteLineRenderer(for: overlay)
        }
        
        public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if views.last?.annotation is MKUserLocation && AppConfig.map.useCustomLocationDot{
                addCustomLocationDot(toAnnotationView: views.last!)
            }
        }
        public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if userLocation.location != nil{
                context.currentAnnouncement = context.announcementHandler.handleAnnouncements(userLocation: userLocation.location!)
                if ((context.currentAnnouncement?.updateMap) != nil){
                    if context.currentAnnouncement!.updateMap{
                        context.addRoute(to: mapView, secondPart: true)
                    }
                }
            }
        }
    }
}

//MARK: Custom Location Marker & Route Line
private extension MapView.Coordinator{
    func addCustomLocationDot(toAnnotationView annotationView:MKAnnotationView){
        let image = UIImage(systemName: AppConfig.map.locationDotSfIcon,withConfiguration: AppConfig.map.locationDotConfig)
        let headingImageView = UIImageView(image: image)
        headingImageView.frame = CGRect(
            x: (annotationView.frame.size.width - image!.size.width) / 2,
            y: (annotationView.frame.size.height - image!.size.height) / 2,
            width: image!.size.width,
            height: image!.size.height
        )
        headingImageView.tintColor = AppConfig.map.locationDotTint
        //View should always be ontop
        headingImageView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        annotationView.insertSubview(headingImageView, at: 0)
    }
    
    func getCustomRouteLineRenderer(for overlay : MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = UIColor.orange.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.green.withAlphaComponent(0.8)
        renderer.lineWidth = 5.0
        return renderer
    }
    
}
//MARK: Route Adding
private extension MapView {
    
    func addRoute(to view: MKMapView,secondPart:Bool) {
        print("add route to Map")
        if secondPart{
            //view.removeOverlay(getRouteLine(secondPart: false))
            for overlay in view.overlays{
                if overlay is MKPolyline {
                    view.removeOverlay(overlay)
                }
            }
            view.addOverlay(getRouteLine(secondPart: true))
        }else{
            view.addOverlay(getRouteLine(secondPart: false))
        }
        /*let start = MKPointAnnotation()
        start.title = "Start"
        start.coordinate = route.points()[0].coordinate
        
        let end = MKPointAnnotation()
        end.title = "End"
        end.coordinate = route.points()[route.pointCount - 1].coordinate
        
        view.addAnnotation(start)
        view.addAnnotation(end)*/
    }
    func getRouteLine(secondPart: Bool) -> MKPolyline{
        var points: [CLLocationCoordinate2D]
        if secondPart{
            points = AppConfig.route.routePoints2
        }else{
            points = AppConfig.route.routePoints
        }
        
        return MKPolyline(coordinates: &points, count: points.count)
    }
}
