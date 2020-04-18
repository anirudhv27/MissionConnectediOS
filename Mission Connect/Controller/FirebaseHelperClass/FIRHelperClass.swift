//
//  FIRHelperClass.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/24/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class FIRHelperClass: NSObject {

    static let sharedInstance = FIRHelperClass()
    
    func saveUserData(emailString: String, nickName:String, fullName: String, graduationYear:String, schoolName:String, imageURL: String ) {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        let userData : [String:Any] = ["AvatarImageURL":imageURL, "Email":emailString, "FullName":fullName, "NickName":nickName, "GraduationYear":graduationYear, "SchoolName":schoolName,"CreatedTimestamp": NSDate().timeIntervalSince1970]
        
        databaseReference.child("users").childByAutoId().setValue(userData)
        
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
        databaseReference.child("clubs").observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    func isExistUser(email:String, completion: @escaping (_ status: Bool) -> Void){
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()
        databaseReference.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
        
            let value = snapshot.value as? Dictionary<String,AnyObject>
            let keyList = value!.keys
            
            for str in keyList {
                let tempDict = value![str] as? Dictionary<String,AnyObject>
                let emailstr = "\(tempDict!["Email"] ?? ""  as AnyObject)"
                
                if email == emailstr {
                    completion(true)
                    break
                }
            }
            completion(false)
        // ...
        }) { (error) in
        print(error.localizedDescription)
        }
    }
    //Event method
    func createEvent(startDate: Date, eventName: String, clubName:String, eventDescription:String, image: UIImage, preview: String) {
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
                
                guard let key = databaseReference.child("events").childByAutoId().key else { return }
                databaseReference.child("events").child(key).setValue(["event_image_url": url.absoluteString, "event_date": df.string(from: startDate), "event_name": eventName, "event_description": eventDescription, "event_club": clubName, "event_preview": preview])
                
                databaseReference.child("clubs").child(clubName).child("events").child(key).setValue(true)
                databaseReference.child("users").observe(.childAdded) { (snapshot) in
                    if snapshot.childSnapshot(forPath: "clubs").hasChild(clubName){
                        databaseReference.child("users").child(snapshot.key).child("events").child(key).child("member_status").setValue("Officer")
                        databaseReference.child("users").child(snapshot.key).child("events").child(key).child("isGoing").setValue(true)
                    }
                }
            }
        }
        
    }
    func editEvent(startDate: Date, eventName: String, clubName:String, eventDescription:String, image: UIImage, preview: String, key: String) {
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
                databaseReference.child("events").child(key).setValue(["event_image_url": url.absoluteString, "event_date": df.string(from: startDate), "event_name": eventName, "event_description": eventDescription, "event_club": clubName, "event_preview": preview])
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
                
                guard let key = databaseReference.child("clubs").childByAutoId().key else { return }
                databaseReference.child("clubs").child(key).setValue(["club_description": clubDescription, "club_image_url": url.absoluteString, "club_name": clubName, "club_preview": clubPreview, "member_numbers": officers.count])
                for id in officers {
                    databaseReference.child("users").child(id).child("clubs").child(key).setValue("Officer")
                }
            }
        }
    }
}

