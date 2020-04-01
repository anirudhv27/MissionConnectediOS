//
//  ClubDetailsViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ClubDetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    var club: Club!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var clubDescriptionLabel: UILabel!
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        navigationController?.delegate = self
        clubNameLabel.text = club.clubName
        clubDescriptionLabel.text = club.clubDescription
    }

    @IBAction func subscribeButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "Subscribe?", message: "Subscribe to \(club.clubName ?? "")?", preferredStyle: .alert)
        let cancelActionBtn = UIAlertAction(title: "No", style: .cancel, handler: { _ in
              self.navigationController?.popToRootViewController(animated: true)
        })
        
        let subscribeActionBtn = UIAlertAction(title: "Subscribe", style: .default, handler: { _ in
            let USER_REF = self.ref.child("users").child(self.user!.uid)
            let clubKey = self.club.clubName?.lowercased().replacingOccurrences(of: " ", with: "")
            USER_REF.child("clubs").child(clubKey!).setValue("member")
            
            self.navigationController?.viewControllers.forEach { ($0 as? ClubListTableViewController)?.tableView.reloadData() }
            
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        alert.addAction(cancelActionBtn)
        alert.addAction(subscribeActionBtn)
        self.present(alert, animated: true)
    }
    
}
