//
//  EventDetailsViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/15/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class EventDetailsViewController1: UIViewController {
    
    @IBOutlet weak var letBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var attendeeLabel: UILabel!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!
    
    var event: Event?
    
    var isOfficer = false
    var isGoing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        topView.setShadow()
        self.letBtn.layer.cornerRadius = 4.0
        
        ref.child("users/\(user!.uid)/events/\(event?.eventID ?? "")/isGoing").observeSingleEvent(of: .value, with: { (snapshot) in
            let val = snapshot.value as! Bool
            self.isGoing = val
            if val {
                self.letBtn.backgroundColor = UIColor.red
                self.letBtn.setTitle("I can't go :(", for: .normal)
            } else {
                self.letBtn.backgroundColor = UIColor.green
                self.letBtn.setTitle("I'm Going!", for: .normal)
            }
        })
        
        if isOfficer {
            letBtn.isHidden = true
        }
        
        titleLabel.text = event?.event_name
        eventImageView.imageFromURL(urlString: event?.eventImageURL ?? "")
        eventDescriptionTextView.text = event?.event_description
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        dateLabel.text = df.string(from: event!.eventDate!)
        attendeeLabel.text = "\(event?.numberOfAttendees ?? 0) People Are Going."
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isGoing {
            self.letBtn.backgroundColor = UIColor.red
            self.letBtn.setTitle("I can't go :(", for: .normal)
        } else {
            self.letBtn.backgroundColor = UIColor.green
            self.letBtn.setTitle("I'm Going!", for: .normal)
        }
    }
    
    @IBAction func imGoingBtn(_ sender: Any) {
        
        var alert: UIAlertController
        if !self.isGoing {
            alert = UIAlertController(title: "Join?", message: "Are you going to \(event?.event_name ?? "")?", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Leave this event?", message: "Leave \(event?.event_name ?? "")?", preferredStyle: .alert)
        }
        let cancelActionBtn = UIAlertAction(title: "No", style: .cancel, handler: { _ in
              self.navigationController?.popToRootViewController(animated: true)
        })
        
        let USER_REF = self.ref.child("users").child(self.user!.uid)
        let eventKey = self.event!.eventID
        
        let subscribeActionBtn = UIAlertAction(title: "Join", style: .default, handler: { _ in
            USER_REF.child("events").child(eventKey!).child("isGoing").setValue(true)
            self.ref.child("events").child(eventKey!).child("member_numbers").setValue(self.event!.numberOfAttendees! + 1)
            self.event!.numberOfAttendees! = self.event!.numberOfAttendees! + 1
            self.letBtn.backgroundColor = UIColor.red
            self.letBtn.setTitle("I can't go :(", for: .normal)
            self.isGoing = true
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        let unsubscribeActionBtn = UIAlertAction(title: "Leave", style: .default, handler: { _ in
            
            USER_REF.child("events").child(eventKey!).child("isGoing").setValue(false)
            self.ref.child("events").child(eventKey!).child("member_numbers").setValue(self.event!.numberOfAttendees! - 1)
            self.event!.numberOfAttendees! = self.event!.numberOfAttendees! - 1
            self.letBtn.backgroundColor = UIColor.green
            self.letBtn.setTitle("I'm Going!", for: .normal)
            self.isGoing = false
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        
        alert.addAction(cancelActionBtn)
        
        if !self.isGoing {
            alert.addAction(subscribeActionBtn)
        } else {
            alert.addAction(unsubscribeActionBtn)
        }
        self.present(alert, animated: true)
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
