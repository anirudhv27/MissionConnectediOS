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
    func createEvent(startDate: String, endDate:String, eventName: String, clubName:String, eventDescription:String, imageURL: String ) {
        var databaseReference = DatabaseReference()
        databaseReference = Database.database().reference()

        databaseReference.child("events").childByAutoId().setValue(["EventImage":imageURL, "EventStartDate":startDate, "EventEndData":endDate, "EventName":eventName, "EventDescription":eventDescription, "ClubName":clubName])
    }
}

