//
//  AnnouncementHandler.swift
//  QuantiBike
//
//  Created by Manuel Lehé on 07.10.22.
//

import Foundation
import AVFAudio
import UIKit
import CoreLocation

struct RouteAnnouncement{
    var action: String
    var location: CLLocation
    var distance: Int
    var wasAnnounced: Bool
    var updateMap: Bool
    
    init(action:String, location: CLLocation,updateMap:Bool) {
        self.action = action
        self.location = location
        self.distance = -1
        self.wasAnnounced = false
        self.updateMap = updateMap
    }
    func getIcon() -> String{
        switch action{
        case "left":
            return AppConfig.annoucememnts.sfIconLeft
        case "left_pocket":
            return AppConfig.annoucememnts.sfIconLeftPocket
        case "right":
            return AppConfig.annoucememnts.sfIconRight
        case "party":
            return AppConfig.annoucememnts.sfIconDone
        default:
            return "questionmark"
        }
    }
    func getText() -> String{
        switch action{
        case "left":
            return AppConfig.annoucememnts.announcementTextLeft
        case "left_pocket":
            return AppConfig.annoucememnts.announcementTextPocket
        case "right":
            return AppConfig.annoucememnts.announcementTextRight
        case "party":
            return AppConfig.annoucememnts.announcementTextDone
        default:
            return "No text found"
        }
    }
    func getAnnouncement() -> String{
        switch action{
        case "left":
            return AppConfig.annoucememnts.announcementLeft
        case "left_pocket":
            return AppConfig.annoucememnts.announcementPocket
        case "right":
            return AppConfig.annoucememnts.announcementRight
        case "party":
            return AppConfig.annoucememnts.announcementDone
        default:
            return "No text found"
        }
    }
}
class AnnouncementHandler{
    
    private let synth = AVSpeechSynthesizer()
    private var announcingPointer = 0
    private var routeAnnouncings: [RouteAnnouncement] = AppConfig.annoucememnts.announcementPoints
    
    func handleAnnouncements(userLocation: CLLocation) -> RouteAnnouncement{
        if announcingPointer >= routeAnnouncings.count{
            return AppConfig.annoucememnts.DoneAnnouncement
        }
        var nextGoal = routeAnnouncings[announcingPointer]
        let currentDistance = userLocation.distance(from: nextGoal.location)
        if currentDistance <= AppConfig.annoucememnts.announcementDistance && !nextGoal.wasAnnounced{
            announceToUser(for: nextGoal.getAnnouncement())
            nextGoal.wasAnnounced = true
            routeAnnouncings[announcingPointer] = nextGoal
        }
        //If distance reached, go to next announcement
        if currentDistance <= AppConfig.annoucememnts.annoucementResolvedDistance{
            announcingPointer += 1
        }
        nextGoal.distance = Int(currentDistance)
        //print("Distance to next goal \(String(describing: currentDistance)) with movement \(nextGoal.text)")
        return nextGoal
    }
    private func announceToUser(for announcement: String){
        let utterance = AVSpeechUtterance(string: announcement)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
}

