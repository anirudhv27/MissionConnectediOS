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
    
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        navigationController?.delegate = self
        clubTitleLabel.text = club.clubName
        descriptionTxtView.text = club.clubDescription
        
        self.topView.setShadow()
        subscribeBtn.layer.cornerRadius = 4.0
        
    }
    
    @IBAction func allEventBtnAction(_ sender: Any) {
        let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "EventsListViewController") as! EventsListViewController
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subscribeBtnAction(_ sender: Any) {
            let alert: UIAlertController = UIAlertController(title: "Subscribe?", message: "Subscribe to \(club.clubName ?? "")?", preferredStyle: .alert)
            let cancelActionBtn = UIAlertAction(title: "No", style: .cancel, handler: { _ in
                  self.navigationController?.popToRootViewController(animated: true)
            })
            
            let subscribeActionBtn = UIAlertAction(title: "Subscribe", style: .default, handler: { _ in
                let USER_REF = self.ref.child("users").child(self.user!.uid)
                let clubKey = String(self.club.clubID!)
                USER_REF.child("clubs").child(clubKey).setValue(true)
            })
            
            alert.addAction(cancelActionBtn)
            alert.addAction(subscribeActionBtn)
            self.present(alert, animated: true)
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
