//
//  FIRHelperClass.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/24/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class FIRHelperClass: NSObject {

    static let sharedInstance = FIRHelperClass()
    
    func saveUserData(emailString: String, fullName: String, school:String, imgURL: String, id: String) {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        let userData : [String:Any] = ["email":emailString, "fullname":fullName, "school":school,"imgurl": imgURL, "isAdmin": false]
        
        databaseReference.child("users").child(id).setValue(userData)
        
       // print(databaseReference)
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping (_ status: Bool, _ imageURL: URL?) -> Void) {
        let timeStamp = "user\(Date().timeIntervalSince1970).jpeg"
        let storageRef = Storage.storage().reference().child("userimages").child(timeStamp)
          
            
            let data = image.pngData()
          //  showHud()
            if data != nil {
                let _ = storageRef.putData(data!, metadata: nil) { (metadata, error) in
                    //hideHud()
                guard metadata != nil else {
                    completion(false, nil)
                    return
                }
                print("complete inside")
                storageRef.downloadURL(completion: { (imageURL, error) in
                    if error != nil {
                        completion(false, nil)
                        return
                    }
                   
                completion(false, imageURL)
                })
            }
        }
    }
    
    func updateEventImageURL(image: UIImage, completion: @escaping (_ status: Bool, _ imageURL: URL?) -> Void) {
        let timeStamp = "event\(Date().timeIntervalSince1970).jpeg"
        let storageRef = Storage.storage().reference().child("eventimages").child(timeStamp)
        let data = image.pngData()
            //  showHud()
            if data != nil {
                let _ = storageRef.putData(data!, metadata: nil) { (metadata, error) in
                //hideHud()
                guard metadata != nil else {
                    completion(false, nil)
                    return
                }
                print("complete inside")
                storageRef.downloadURL(completion: { (imageURL, error) in
                    if error != nil {
                        completion(false, nil)
                        return
                    }
                    completion(false, imageURL)
                })
                
            }
        }
    }
          
    func getAllClubList() {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        databaseReference.child("schools").child(schoolName).child("clubs").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
        
            let value = snapshot.value as? Dictionary<String,AnyObject>
            let username = value?["username"] as? String ?? ""
            print(username)
            // let user = User(username: username)
        
        // ...
        }) { (error) in
        print(error.localizedDescription)
        }
    }
    
    func isExistUser(email: String, completion: @escaping (_ status: Bool) -> Void){
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        databaseReference.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
        
            let value = snapshot.value as? Dictionary<String,AnyObject>
            let keyList = value!.keys
            var emailfound = false
            
            for str in keyList {
                let tempDict = value![str] as? Dictionary<String,AnyObject>
                let emailstr = "\(tempDict!["email"] ?? ""  as AnyObject)"
                
                if email == emailstr {
                    emailfound = true
                    break
                }
            }
            
            completion(emailfound)
            
        // ...
        }) { (error) in
        print(error.localizedDescription)
        }
    }
    
    func getIsAdmin(user: User,completion: @escaping (_ status: Bool) -> Void){
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        databaseReference.child("users").child(user.uid).child("isAdmin").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? Bool
            if value == true {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    //Event method
    func createEvent(startDate: Date, eventName: String, clubName:String, eventDescription:String, image: UIImage, preview: String, completion: @escaping ()->()) {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Somthing's wrong!")
            return
        }
        let imageName = "event\(Date().timeIntervalSince1970)"
        
        let imageReference = Storage.storage().reference().child("eventimages").child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if err != nil {
                print("somethings wrong!")
                return
            }
            
            imageReference.downloadURL { (url, err) in
                if err != nil {
                    print("somethings wrong!")
                    return
                }
                guard let url = url else {
                    print("Somthing's wrong!")
                    return
                }
                
                guard let key = databaseReference.child("schools").child(schoolName).child("events").childByAutoId().key else { return }
                
                databaseReference.child("schools").child(schoolName).child("events").child(key).setValue(["event_image_url": url.absoluteString, "event_date": df.string(from: startDate), "event_name": eventName, "event_description": eventDescription, "event_club": clubName, "event_preview": preview, "member_numbers": 0])
                databaseReference.child("schools").child(schoolName).child("events").child(key).setValue(["event_image_url": url.absoluteString, "event_date": df.string(from: startDate), "event_name": eventName, "event_description": eventDescription, "event_club": clubName, "event_preview": preview, "member_numbers": 0]) { (err, ref) in
                    completion()
                }
                
                databaseReference.child("schools").child(schoolName).child("clubs").child(clubName).child("events").child(key).setValue(true)
                databaseReference.child("users").observe(.childAdded) { (snapshot) in
                    if snapshot.childSnapshot(forPath: "clubs").hasChild(clubName){
                        if (snapshot.childSnapshot(forPath: "clubs").childSnapshot(forPath: clubName).value as! String == "Officer") {
                            databaseReference.child("users").child(snapshot.key).child("events").child(key).child("member_status").setValue("Officer")
                            databaseReference.child("users").child(snapshot.key).child("events").child(key).child("isGoing").setValue(true)
                        } else {
                            databaseReference.child("users").child(snapshot.key).child("events").child(key).child("member_status").setValue("Member")
                            databaseReference.child("users").child(snapshot.key).child("events").child(key).child("isGoing").setValue(false)
                        }
                    }
                }
            }
        }
        
    }
    func editEvent(startDate: Date, eventName: String, clubName:String, eventDescription:String, image: UIImage, preview: String, key: String, completion: @escaping () -> ()) {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Somthing's wrong!")
            return
        }
        let imageName = "event\(Date().timeIntervalSince1970)"
        
        let imageReference = Storage.storage().reference().child("eventimages").child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if err != nil {
                print("somethings wrong!")
                return
            }
            imageReference.downloadURL { (url, err) in
                if err != nil {
                    print("somethings wrong!")
                    return
                }
                guard let url = url else {
                    print("Somthing's wrong!")
                    return
                }
                databaseReference.child("schools").child(schoolName).child("events").child(key).setValue(["event_image_url": url.absoluteString, "event_date": df.string(from: startDate), "event_name": eventName, "event_description": eventDescription, "event_club": clubName, "event_preview": preview]) { (err, ref) in
                    if err == nil {
                        completion()
                    }
                }
            }
        }
    }
    func createClub(clubName: String, clubPreview: String, clubDescription: String, image: UIImage, officers: [String]) {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Somthing's wrong!")
            return
        }
        let imageName = "club\(Date().timeIntervalSince1970)"
        
        let imageReference = Storage.storage().reference().child("clubimages").child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if err != nil {
                print("somethings wrong!")
                return
            }
            
            imageReference.downloadURL { (url, err) in
                if err != nil {
                    print("somethings wrong!")
                    return
                }
                guard let url = url else {
                    print("Somthing's wrong!")
                    return
                }
                
                guard let key = databaseReference.child("schools").child(schoolName).child("clubs").childByAutoId().key else { return }
                databaseReference.child("schools").child(schoolName).child("clubs").child(key).setValue(["club_description": clubDescription, "club_image_url": url.absoluteString, "club_name": clubName, "club_preview": clubPreview, "member_numbers": officers.count, "isApproved": false])
                for id in officers {
                    databaseReference.child("users").child(id).child("clubs").child(key).setValue("Officer")
                }
            }
        }
    }
    func editClub(clubID: String, clubName: String, clubPreview: String, clubDescription: String, image: UIImage, officers: [String]) {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()

        databaseReference.child("schools").child(schoolName).child("clubs").child(clubID).child("events").observeSingleEvent(of: .value) { (snapshot) in
            let eventsDict = snapshot.value as? [String: Bool]
            var eventNames: [String] = []
            if (eventsDict != nil) {
                eventNames = [String] (eventsDict!.keys)
            }
            
            guard let data = image.jpegData(compressionQuality: 1.0) else {
                print("Somthing's wrong!")
                return
            }
            
            let imageName = "club\(Date().timeIntervalSince1970)"
            
            let imageReference = Storage.storage().reference().child("clubimages").child(imageName)
            
            imageReference.putData(data, metadata: nil) { (metadata, err) in
                if err != nil {
                    print("somethings wrong!")
                    return
                }
                
                imageReference.downloadURL { (url, err) in
                    if err != nil {
                        print("somethings wrong!")
                        return
                    }
                    guard let url = url else {
                        print("Somthing's wrong!")
                        return
                    }
                    
                    databaseReference.child("schools").child(schoolName).child("clubs").child(clubID).setValue(["club_description": clubDescription, "club_image_url": url.absoluteString, "club_name": clubName, "club_preview": clubPreview, "member_numbers": officers.count, "isApproved": true, "events": eventsDict as Any]) //need to include previous events over here
                    
                    databaseReference.child("users").observeSingleEvent(of: .value) { (snapshot) in
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            if officers.contains(snap.key) {
                                databaseReference.child("users").child(snap.key).child("clubs").child(clubID).setValue("Officer")
                            } else {
                                 if snap.childSnapshot(forPath: "clubs").hasChild(clubID) {
                                    databaseReference.child("users").child(snap.key).child("clubs").child(clubID).setValue("Member")
                                }
                            }
                            for eventID in eventNames {
                                if snap.childSnapshot(forPath: "events").hasChild(eventID) {
                                    if officers.contains(snap.key) {
                                        databaseReference.child("users").child(snap.key).child("events").child(eventID).child("member_status").setValue("Officer")
                                    } else {
                                        databaseReference.child("users").child(snap.key).child("events").child(eventID).child("member_status").setValue("Member")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

