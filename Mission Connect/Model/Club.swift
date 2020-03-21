//
//  Club.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import Foundation

class Club: Codable {
    var clubName: String?
    var clubDescription: String?
    var clubImageURL: String?
    var clubID: String?
    
    static func ==(lhs: Club, rhs: Club) -> Bool {
        return lhs.clubName == rhs.clubName && lhs.clubDescription == rhs.clubDescription
    }
}
