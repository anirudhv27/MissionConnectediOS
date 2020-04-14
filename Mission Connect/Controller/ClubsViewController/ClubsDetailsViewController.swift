//
//  ClubsDetailsViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/16/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class ClubsDetailsViewController: UIViewController, UINavigationControllerDelegate {

    var club: Club!
    
    @IBOutlet weak var allEventBtn: UIButton!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var clubTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!
    var isMyClub: Bool = true
    var isOfficer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        navigationController?.delegate = self
        clubTitleLabel.text = club.clubName
        descriptionTxtView.text = club.clubDescription
        memberLabel.text = "Members: \(club.numberOfMembers ?? -1) joined"
        descriptionTxtView.isEditable = false
        imageView.imageFromURL(urlString: club.clubImageURL ?? "")
        ref.child("users").child(self.user!.uid).child("clubs").observeSingleEvent(of: .value, with: {(snapshot)-> Void in
            if snapshot.hasChild(self.club.clubID!){
                self.isMyClub = true
                if snapshot.childSnapshot(forPath: self.club.clubID!).value as? String != "Member"{
                    self.isOfficer = true
                }
            } else {
                self.isMyClub = false
            }
        })
        
        self.topView.setShadow()
        subscribeBtn.layer.cornerRadius = 4.0
    }
    override func viewDidAppear(_ animated: Bool) {
        if isMyClub {
            self.subscribeBtn.setTitle("Unsubscribe", for: .normal)
            self.subscribeBtn.backgroundColor = UIColor.red
        } else {
            self.subscribeBtn.setTitle("Subscribe", for: .normal)
            self.subscribeBtn.backgroundColor = UIColor.green
        }
    }
    
    @IBAction func allEventBtnAction(_ sender: Any) {
        let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "EventListTableViewController") as! EventListTableViewController
        objVC.club = club!
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subscribeBtnAction(_ sender: Any) {
        var alert: UIAlertController
        if !self.isMyClub {
            alert = UIAlertController(title: "Join?", message: "Subscribe to \(club.clubName)?", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Leave this Club?", message: "Leave \(club.clubName)?", preferredStyle: .alert)
        }
        let cancelActionBtn = UIAlertAction(title: "No", style: .cancel, handler: { _ in
              self.navigationController?.popToRootViewController(animated: true)
        })
        
        let subscribeActionBtn = UIAlertAction(title: "Join", style: .default, handler: { _ in
            let USER_REF = self.ref.child("users").child(self.user!.uid)
            let clubKey = String(self.club.clubID!)
            USER_REF.child("clubs").child(clubKey).setValue("Member")
            let EVENTS_REF = self.ref.child("clubs").child(clubKey).child("events")
            EVENTS_REF.observe(.childAdded, with: { (snapshot) -> Void in
                let event = snapshot.key
                USER_REF.child("events").child(event).child("member_status").setValue("Member")
                USER_REF.child("events").child(event).child("isGoing").setValue(false)
            })
            self.ref.child("clubs").child(clubKey).child("member_numbers").setValue(self.club.numberOfMembers! + 1)
            self.club.numberOfMembers = self.club.numberOfMembers! + 1
            self.subscribeBtn.titleLabel?.text = "Unsubscribe"
            self.subscribeBtn.backgroundColor = UIColor.red
            self.isMyClub = true
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        let unsubscribeActionBtn = UIAlertAction(title: "Leave", style: .default, handler: { _ in
            let USER_REF = self.ref.child("users").child(self.user!.uid)
            let clubKey = String(self.club.clubID!)
            USER_REF.child("clubs").child(clubKey).removeValue()
            let EVENTS_REF = self.ref.child("clubs").child(clubKey).child("events")
            EVENTS_REF.observe(.childAdded, with: { (snapshot) -> Void in
                let event = snapshot.key
                print(event)
                USER_REF.child("events").child(event).removeValue()
            })
            self.ref.child("clubs").child(clubKey).child("member_numbers").setValue(self.club.numberOfMembers! - 1)
            self.club.numberOfMembers = self.club.numberOfMembers! - 1
            self.subscribeBtn.titleLabel?.text = "Subscribe"
            self.subscribeBtn.backgroundColor = UIColor.green
            self.isMyClub = false
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        
        alert.addAction(cancelActionBtn)
        if !self.isMyClub {
            alert.addAction(subscribeActionBtn)
        } else {
            alert.addAction(unsubscribeActionBtn)
        }
        self.present(alert, animated: true)
        self.viewDidLoad()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
