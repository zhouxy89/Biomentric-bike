//
//  AppConfig.swift
//  QuantiBike
//
//  Created by Manuel Lehé on 07.10.22.
//

import Foundation
import MapKit

struct AppConfig{
    struct map{
        static let zoomEnables = false
        static let scrollEnabled = true
        static let rotateEnabled = false
        static let showUserLocation = true
        static let useCustomLocationDot = true
        static let zoomLevel = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 600, maxCenterCoordinateDistance: 600)
        static let userTrackingMode = MKUserTrackingMode.followWithHeading
        static let tintAdjustMode = UIView.TintAdjustmentMode.normal
        static let tintColor = UIColor.white
        static let poiFilter = MKPointOfInterestFilter.excludingAll
        static let locationDotSfIcon = "arrowtriangle.up.circle.fill"
        static let locationDotConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        static let locationDotTint = UIColor.systemOrange
    }
    struct location{
        static let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        static let startPosition = CLLocationCoordinate2D(latitude:49.872081, longitude: 8.662480)
        static let accuracy = kCLLocationAccuracyBestForNavigation // Best Accuracy + Sensors and other sources
        static let distanceFilter = kCLDistanceFilterNone //Continous updates
        static let activityType = CLActivityType.otherNavigation // Navigation other than car, alternativ would be fitness
        static let headingFilter = kCLHeadingFilterNone
    }
    struct annoucememnts{
        static let announcementRight = "Please turn right in 50 meters"
        static let announcementLeft = "Please turn left in 50 meters"
        static let announcementPocket = "Please turn Left while using the pocket in 50 meters"
        static let announcementDone = "You reached the goal. Congratulation!"
        static let announcementTextRight = "Turn Right"
        static let announcementTextLeft = "Turn Left"
        static let announcementTextPocket = "Use Pocket to Turn Left"
        static let announcementTextDone = "End of Route"
        static let sfIconRight = "arrow.turn.up.right"
        static let sfIconLeft = "arrow.turn.up.left"
        static let sfIconLeftPocket = "arrow.turn.up.forward.iphone"
        static let sfIconDone = "party.popper.fill"
        static let announcementDistance = 50.0
        static let annoucementResolvedDistance = 10.0 // declares at which distance location was reached
        static let DoneAnnouncement = RouteAnnouncement(action: "party", location: CLLocation(latitude: 51.50555063856493,longitude:  -0.17267963042283735),updateMap: false)
        static let announcementPoints = [
            //RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86984927494878, longitude: 8.663567654303998)), //DEBUG CONTENT
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.872095498769035,longitude: 8.66254308712667),updateMap: false),
            RouteAnnouncement(action: "left_pocket", location: CLLocation(latitude: 49.87077091039763,longitude: 8.662397220934208),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.870764631383445,longitude: 8.664751073208041),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.871551820714416,longitude: 8.664825752890415),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.87203994822253,longitude: 8.663631025333185),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.870812756569926,longitude: 8.663599038400942),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.870771495354546,longitude: 8.662479004144812),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.867653897267,longitude: 8.66377156963665),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86730754815766,longitude: 8.661947699245687),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.865482521861715,longitude: 8.662541888815223),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86608864707826,longitude: 8.664866930616018),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.86748738573474,longitude: 8.664122910228787),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.867858130777755,longitude: 8.667588940525736),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.86941679483723,longitude: 8.667818460170691),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.86919300348411,longitude: 8.66970719285014),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86804391805181,longitude: 8.669448220904009),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86789247937046,longitude: 8.673430698758898),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.868756930385565,longitude: 8.673802289159731),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.86846492102661,longitude: 8.675832206523895),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86751302416499,longitude: 8.675538016770265),updateMap: false),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86741058033546,longitude: 8.678844684674779),updateMap: true),
            RouteAnnouncement(action: "left", location: CLLocation(latitude: 49.86958382757501,longitude: 8.666233824745829),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.86864580044951,longitude: 8.666102136009144),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.868590553594174,longitude: 8.663033405134215),updateMap: false),
            RouteAnnouncement(action: "left_pocket", location: CLLocation(latitude: 49.87076375076275,longitude: 8.662348467354725),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.87081464390739,longitude: 8.660767962400968),updateMap: false),
            RouteAnnouncement(action: "right", location: CLLocation(latitude: 49.87211341611788,longitude: 8.661090694538558),updateMap: false)
        ]
    }
    
    struct route{
        // Points exported from gpx file
        static let routePoints = [
            CLLocationCoordinate2D(latitude:49.872081, longitude: 8.662480),
            CLLocationCoordinate2D(latitude:49.872013, longitude: 8.662472),
            CLLocationCoordinate2D(latitude:49.871880, longitude: 8.662457),
            CLLocationCoordinate2D(latitude:49.871257, longitude: 8.662355),
            CLLocationCoordinate2D(latitude:49.870854, longitude: 8.662296),
            CLLocationCoordinate2D(latitude:49.870785, longitude: 8.662296),
            CLLocationCoordinate2D(latitude:49.870785, longitude: 8.662356),
            CLLocationCoordinate2D(latitude:49.870785, longitude: 8.662379),
            CLLocationCoordinate2D(latitude:49.870784, longitude: 8.662434),
            CLLocationCoordinate2D(latitude:49.870784, longitude: 8.662484),
            CLLocationCoordinate2D(latitude:49.870794, longitude: 8.663585),
            CLLocationCoordinate2D(latitude: 49.870758, longitude: 8.664736),
            CLLocationCoordinate2D(latitude: 49.870739, longitude: 8.664733),
            CLLocationCoordinate2D(latitude: 49.870758, longitude: 8.664736),
            CLLocationCoordinate2D(latitude: 49.871208, longitude: 8.664786),
            CLLocationCoordinate2D(latitude: 49.871597, longitude: 8.664842),
            CLLocationCoordinate2D(latitude: 49.871637, longitude: 8.664769),
            CLLocationCoordinate2D(latitude: 49.871846, longitude: 8.664343),
            CLLocationCoordinate2D(latitude: 49.872034, longitude: 8.663962),
            CLLocationCoordinate2D(latitude: 49.872046, longitude: 8.663618),
            CLLocationCoordinate2D(latitude: 49.872046, longitude: 8.663601),
            CLLocationCoordinate2D(latitude: 49.871408, longitude: 8.663578),
            CLLocationCoordinate2D(latitude: 49.871230, longitude: 8.663583),
            CLLocationCoordinate2D(latitude: 49.870969, longitude: 8.663584),
            CLLocationCoordinate2D(latitude:49.870794, longitude: 8.663585),
            CLLocationCoordinate2D(latitude: 49.870784, longitude: 8.662484),
            CLLocationCoordinate2D(latitude: 49.870784, longitude: 8.662434),
            CLLocationCoordinate2D(latitude: 49.870785, longitude: 8.662356),
            CLLocationCoordinate2D(latitude:49.870785, longitude: 8.662296),
            CLLocationCoordinate2D(latitude:49.870670, longitude: 8.662280),
            CLLocationCoordinate2D(latitude:49.869454, longitude: 8.662131),
            CLLocationCoordinate2D(latitude:49.869426, longitude: 8.662226),
            CLLocationCoordinate2D(latitude:49.869383, longitude: 8.662232),
            CLLocationCoordinate2D(latitude:49.869310, longitude: 8.662244),
            CLLocationCoordinate2D(latitude:49.869242, longitude: 8.662268),
            CLLocationCoordinate2D(latitude:49.869122, longitude: 8.662283),
            CLLocationCoordinate2D(latitude:49.869031, longitude: 8.662306),
            CLLocationCoordinate2D(latitude:49.868634, longitude: 8.662743),
            CLLocationCoordinate2D(latitude:49.868615, longitude: 8.662844),
            CLLocationCoordinate2D(latitude:49.868547, longitude: 8.662914),
            CLLocationCoordinate2D(latitude:49.868383, longitude: 8.663078),
            CLLocationCoordinate2D(latitude:49.867707, longitude: 8.663766),
            CLLocationCoordinate2D(latitude:49.867617, longitude: 8.663861),
            CLLocationCoordinate2D(latitude:49.867576, longitude: 8.663903),
            CLLocationCoordinate2D(latitude:49.867546, longitude: 8.663636),
            CLLocationCoordinate2D(latitude:49.867375, longitude: 8.662285),
            CLLocationCoordinate2D(latitude:49.867329, longitude: 8.661926),
            CLLocationCoordinate2D(latitude:49.867327, longitude: 8.661913),
            CLLocationCoordinate2D(latitude:49.866922, longitude: 8.662049),
            CLLocationCoordinate2D(latitude:49.866622, longitude: 8.662151),
            CLLocationCoordinate2D(latitude:49.866541, longitude: 8.662178),
            CLLocationCoordinate2D(latitude:49.866240, longitude: 8.662278),
            CLLocationCoordinate2D(latitude:49.865471, longitude: 8.662530),
            CLLocationCoordinate2D(latitude:49.865459, longitude: 8.662538),
            CLLocationCoordinate2D(latitude:49.865471, longitude: 8.662530),
            CLLocationCoordinate2D(latitude:49.865887, longitude: 8.664062),
            CLLocationCoordinate2D(latitude:49.866085, longitude: 8.664759),
            CLLocationCoordinate2D(latitude:49.866137, longitude: 8.664950),
            CLLocationCoordinate2D(latitude:49.866151, longitude: 8.665013),
            CLLocationCoordinate2D(latitude:49.866162, longitude: 8.665056),
            CLLocationCoordinate2D(latitude:49.866824, longitude: 8.664650),
            CLLocationCoordinate2D(latitude:49.866840, longitude: 8.664483),
            CLLocationCoordinate2D(latitude:49.867172, longitude: 8.664247),
            CLLocationCoordinate2D(latitude:49.867245, longitude: 8.664190),
            CLLocationCoordinate2D(latitude:49.867502, longitude: 8.664260),
            CLLocationCoordinate2D(latitude:49.867622, longitude: 8.664397),
            CLLocationCoordinate2D(latitude:49.867624, longitude: 8.664422),
            CLLocationCoordinate2D(latitude:49.867631, longitude: 8.664514),
            CLLocationCoordinate2D(latitude:49.867644, longitude: 8.664672),
            CLLocationCoordinate2D(latitude:49.867713, longitude: 8.665558),
            CLLocationCoordinate2D(latitude:49.867748, longitude: 8.666016),
            CLLocationCoordinate2D(latitude:49.867752, longitude: 8.666058),
            CLLocationCoordinate2D(latitude:49.867784, longitude: 8.666544),
            CLLocationCoordinate2D(latitude:49.867857, longitude: 8.667656),
            CLLocationCoordinate2D(latitude:49.868243, longitude: 8.667662),
            CLLocationCoordinate2D(latitude:49.868293, longitude: 8.667663),
            CLLocationCoordinate2D(latitude:49.868654, longitude: 8.667708),
            CLLocationCoordinate2D(latitude:49.869286, longitude: 8.667760),
            CLLocationCoordinate2D(latitude:49.869428, longitude: 8.667772),
            CLLocationCoordinate2D(latitude:49.869387, longitude: 8.668171),
            CLLocationCoordinate2D(latitude:49.869220, longitude: 8.669694),
            CLLocationCoordinate2D(latitude:49.868825, longitude: 8.669600),
            CLLocationCoordinate2D(latitude:49.868663, longitude: 8.669561),
            CLLocationCoordinate2D(latitude:49.868356, longitude: 8.669508),
            CLLocationCoordinate2D(latitude:49.868139, longitude: 8.669454),
            CLLocationCoordinate2D(latitude:49.867993, longitude: 8.669418),
            CLLocationCoordinate2D(latitude:49.868004, longitude: 8.669604),
            CLLocationCoordinate2D(latitude:49.868012, longitude: 8.669756),
            CLLocationCoordinate2D(latitude:49.868112, longitude: 8.671329),
            CLLocationCoordinate2D(latitude:49.868111, longitude: 8.671505),
            CLLocationCoordinate2D(latitude:49.867963, longitude: 8.672779),
            CLLocationCoordinate2D(latitude:49.867860, longitude: 8.673405),
            CLLocationCoordinate2D(latitude:49.868555, longitude: 8.673671),
            CLLocationCoordinate2D(latitude:49.868738, longitude: 8.673741),
            CLLocationCoordinate2D(latitude:49.868650, longitude: 8.674558),
            CLLocationCoordinate2D(latitude:49.868480, longitude: 8.675791),
            CLLocationCoordinate2D(latitude:49.867715, longitude: 8.675567),
            CLLocationCoordinate2D(latitude:49.867486, longitude: 8.675499),
            CLLocationCoordinate2D(latitude:49.867339, longitude: 8.676400),
            CLLocationCoordinate2D(latitude:49.867325, longitude: 8.677059),
            CLLocationCoordinate2D(latitude:49.867366, longitude: 8.677874),
            CLLocationCoordinate2D(latitude:49.867378, longitude: 8.678070)
            ]
        static let routePoints2 = [
            CLLocationCoordinate2D(latitude:49.867486, longitude: 8.675499),
            CLLocationCoordinate2D(latitude:49.867339, longitude: 8.676400),
            CLLocationCoordinate2D(latitude:49.867325, longitude: 8.677059),
            CLLocationCoordinate2D(latitude:49.867366, longitude: 8.677874),
            CLLocationCoordinate2D(latitude:49.867378, longitude: 8.678070),
            CLLocationCoordinate2D(latitude:49.867428, longitude: 8.678631),
            CLLocationCoordinate2D(latitude:49.867437, longitude: 8.678728),
            CLLocationCoordinate2D(latitude:49.867445, longitude: 8.678885),
            CLLocationCoordinate2D(latitude:49.867449, longitude: 8.678963),
            CLLocationCoordinate2D(latitude:49.867463, longitude: 8.679101),
            CLLocationCoordinate2D(latitude:49.867611, longitude: 8.678899),
            CLLocationCoordinate2D(latitude:49.867656, longitude: 8.678857),
            CLLocationCoordinate2D(latitude:49.868257, longitude: 8.678191),
            CLLocationCoordinate2D(latitude:49.868293, longitude: 8.677852),
            CLLocationCoordinate2D(latitude:49.868284, longitude: 8.677560),
            CLLocationCoordinate2D(latitude:49.868387, longitude: 8.676529),
            CLLocationCoordinate2D(latitude:49.868396, longitude: 8.676433),
            CLLocationCoordinate2D(latitude:49.868480, longitude: 8.675791),
            CLLocationCoordinate2D(latitude:49.868482, longitude: 8.675782),
            CLLocationCoordinate2D(latitude:49.868650, longitude: 8.674558),
            CLLocationCoordinate2D(latitude:49.868738, longitude: 8.673741),
            CLLocationCoordinate2D(latitude:49.868856, longitude: 8.672914),
            CLLocationCoordinate2D(latitude:49.868974, longitude: 8.672053),
            CLLocationCoordinate2D(latitude:49.869018, longitude: 8.671747),
            CLLocationCoordinate2D(latitude:49.869067, longitude: 8.671242),
            CLLocationCoordinate2D(latitude:49.869135, longitude: 8.670555),
            CLLocationCoordinate2D(latitude:49.869161, longitude: 8.670286),
            CLLocationCoordinate2D(latitude:49.869220, longitude: 8.669694),
            CLLocationCoordinate2D(latitude:49.869387, longitude: 8.668171),
            CLLocationCoordinate2D(latitude:49.869428, longitude: 8.667772),
            CLLocationCoordinate2D(latitude:49.869455, longitude: 8.667506),
            CLLocationCoordinate2D(latitude:49.869585, longitude: 8.666152),
            CLLocationCoordinate2D(latitude:49.869054, longitude: 8.666107),
            CLLocationCoordinate2D(latitude:49.868635, longitude: 8.666071),
            CLLocationCoordinate2D(latitude:49.868628, longitude: 8.665155),
            CLLocationCoordinate2D(latitude:49.868624, longitude: 8.664501),
            CLLocationCoordinate2D(latitude:49.868602, longitude: 8.663068),
            CLLocationCoordinate2D(latitude:49.868547, longitude: 8.662914),
            CLLocationCoordinate2D(latitude:49.868615, longitude: 8.662844),
            CLLocationCoordinate2D(latitude:49.868739, longitude: 8.662827),
            CLLocationCoordinate2D(latitude:49.869103, longitude: 8.662487),
            CLLocationCoordinate2D(latitude:49.869242, longitude: 8.662268),
            CLLocationCoordinate2D(latitude:49.869241, longitude: 8.662299),
            CLLocationCoordinate2D(latitude:49.869229, longitude: 8.662491),
            CLLocationCoordinate2D(latitude:49.869257, longitude: 8.662471),
            CLLocationCoordinate2D(latitude:49.869283, longitude: 8.662453),
            CLLocationCoordinate2D(latitude:49.869383, longitude: 8.662341),
            CLLocationCoordinate2D(latitude:49.869383, longitude: 8.662294),
            CLLocationCoordinate2D(latitude:49.870667, longitude: 8.662418),
            CLLocationCoordinate2D(latitude:49.870784, longitude: 8.662434),
            CLLocationCoordinate2D(latitude:49.870785, longitude: 8.662356),
            CLLocationCoordinate2D(latitude:49.870785, longitude: 8.662296),
            CLLocationCoordinate2D(latitude:49.870784, longitude: 8.662211),
            CLLocationCoordinate2D(latitude:49.870788, longitude: 8.661933),
            CLLocationCoordinate2D(latitude:49.870801, longitude: 8.660706),
            CLLocationCoordinate2D(latitude:49.871231, longitude: 8.660800),
            CLLocationCoordinate2D(latitude:49.871298, longitude: 8.660814),
            CLLocationCoordinate2D(latitude:49.872053, longitude: 8.661015),
            CLLocationCoordinate2D(latitude:49.872149, longitude: 8.661037),
            CLLocationCoordinate2D(latitude:49.872099, longitude: 8.662086)
        ]
    }
}
