//
//  Club.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import Foundation

class Club: Codable, Comparable {
    static func < (lhs: Club, rhs: Club) -> Bool {
        return lhs.clubName! < rhs.clubName!
    }
    
    var clubName: String?
    var clubPreview: String?
    var clubDescription: String?
    var clubImageURL: String?
    var clubID: String?
    var numberOfMembers: Int?
    
    static func ==(lhs: Club, rhs: Club) -> Bool {
        return lhs.clubName == rhs.clubName && lhs.clubDescription == rhs.clubDescription
    }
}
