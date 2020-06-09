//
//  Event.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import Foundation

class Event: Comparable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.eventID == rhs.eventID
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        if (lhs.eventDate! == rhs.eventDate!) {
            return lhs.event_name! < rhs.event_name!
        }
        return lhs.eventDate! < rhs.eventDate!
    }
    
    var event_name: String?
    var event_club: String?
    var event_description: String?
    var eventImageURL: String?
    var eventDate: Date?
    var eventID: String?
    var eventPreview: String?
    var numberOfAttendees: Int?
}
