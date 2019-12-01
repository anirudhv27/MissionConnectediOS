//
//  Event.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import Foundation

class Event {
    var eventTitle: String
    var clubName: String
    var eventDescription: String
    
    init(eventTitle: String, clubName: String, eventDescription: String) {
        self.eventTitle = eventTitle
        self.clubName = clubName
        self.eventDescription = eventDescription
    }
}
