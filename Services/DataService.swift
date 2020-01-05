////
////  DataService.swift
////  Mission Connect
////
////  Created by Anirudh Valiveru on 1/2/20.
////  Copyright © 2020 Anirudh Valiveru. All rights reserved.
////
//
//import Foundation
//import FirebaseDatabase
//import FirebaseAuth
//
//let DB_BASE = Database.database().reference()
//
//class DataService {
//    static let instance = DataService()
//
//    private var _REF_BASE = DB_BASE
//    private var _REF_USERS = DB_BASE.child("users")
//    private var _REF_CLUBS = DB_BASE.child("clubs")
//    private var _REF_EVENTS = DB_BASE.child("events")
//
//    var REF_BASE: DatabaseReference {
//        return _REF_BASE
//    }
//
//    var REF_USERS: DatabaseReference {
//        return _REF_USERS
//    }
//
//    var REF_CLUBS: DatabaseReference {
//        return _REF_CLUBS
//    }
//
//    var REF_EVENTS: DatabaseReference {
//        return _REF_EVENTS
//    }
//
//    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
//        REF_USERS.child(uid).updateChildValues(userData)
//    }
//
//    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
//        if let groupKey = groupKey {
//            let values = [
//                "content": message,
//                "senderId": uid
//            ]
//
//            REF_CLUBS.child(groupKey).child("messages").childByAutoId().updateChildValues(values)
//            sendComplete(true)
//        } else {
//            let values = [
//                "content": message,
//                "senderId": uid
//            ]
//            REF_FEED.childByAutoId().updateChildValues(values)
//            sendComplete(true)
//        }
//    }
//
//    func createGroup(title: String, description: String, ids: [String], createComplete: @escaping (_ created: Bool) -> ()) {
//        let values: [String: Any] = [
//            "title": title,
//            "description": description,
//            "members": ids
//        ]
//
//        REF_GROUPS.childByAutoId().updateChildValues(values)
//        createComplete(true)
//    }
//
//    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
//        var messageArray = [Message]()
//
//        REF_FEED.observeSingleEvent(of: .value) { (feedSnapshot) in
//            guard let feedSnapshot = feedSnapshot.children.allObjects as? [DataSnapshot]
//                else { return }
//
//            for message in feedSnapshot {
//                let content = message.childSnapshot(forPath: "content").value as! String
//                let senderID = message.childSnapshot(forPath: "senderId").value as! String
//
//                let message = Message(content: content, senderId: senderID)
//                messageArray.append(message)
//            }
//
//            handler(messageArray)
//        }
//    }
//
//    func getAllClubFeedMessages(club: Club, handler: @escaping (_ events: [Event]) -> ()) {
//        var eventArray = [Event]()
//
//        REF_CLUBS.child(club.key).child("messages").observeSingleEvent(of: .value) { (feedSnapshot) in
//            guard let feedSnapshot = feedSnapshot.children.allObjects as? [DataSnapshot]
//                else { return }
//
//            for message in feedSnapshot {
//                let content = message.childSnapshot(forPath: "content").value as! String
//                let senderID = message.childSnapshot(forPath: "senderId").value as! String
//
//                let message = Message(content: content, senderId: senderID)
//                messageArray.append(message)
//            }
//
//            handler(messageArray)
//        }
//    }
//
//    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
//        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot]
//            else { return }
//
//            for user in userSnapshot {
//                if(user.key == uid) {
//                    handler(user.childSnapshot(forPath: "email").value as! String)
//                }
//            }
//        }
//    }
//
//    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
//        var emailArray = [String]()
//
//        REF_USERS.observe(.value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot]
//                else { return }
//
//            for user in userSnapshot {
//                let userEmail = user.childSnapshot(forPath: "email").value as! String
//
//                if(userEmail.contains(query)) && userEmail != Auth.auth().currentUser!.email {
//                    emailArray.append(userEmail)
//                }
//            }
//
//            handler(emailArray)
//        }
//    }
//
//    func getIds(forUsername usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
//        var idArray = [String]()
//
//        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot]
//                else { return }
//
//            for user in userSnapshot {
//                let userEmail = user.childSnapshot(forPath: "email").value as! String
//
//                if(usernames.contains(userEmail)) {
//                    idArray.append(user.key)
//                }
//            }
//
//            handler(idArray)
//        }
//    }
//
//    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
//        var groupsArray = [Group]()
//
//        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
//            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot]
//                else { return }
//
//            for group in groupSnapshot {
//                let title = group.childSnapshot(forPath: "title").value as! String
//                let description = group.childSnapshot(forPath: "description").value as! String
//                let key = group.key
//                let members = group.childSnapshot(forPath: "members").value as! [String]
//                let memberCount = members.count
//
//                let groupInstance = Group(title: title, description: description, key: key, memberCount: memberCount, members: members)
//
//                if(members.contains((Auth.auth().currentUser?.email)!)) {
//                    groupsArray.append(groupInstance)
//                }
//            }
//
//            handler(groupsArray)
//        }
//    }
//}

