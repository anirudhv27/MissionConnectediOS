//
//  ClubListTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 12/22/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class ClubListTableViewController: UITableViewController {

    var clubNames: [String] = []
    var clubs: [Club] = []
    
    var selectedClub: Club!
    let CLUBS_REF = Database.database().reference().child("clubs")
    var REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchClubs()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        clubs = [Club]()
    }
    
    func fetchClubs() {
        clubNames = [String]()
        REF.observe(.childAdded, with: { (snapshot) -> Void in
            self.clubNames.append(snapshot.key)
        })
        
        CLUBS_REF.observe(.childAdded, with: { (snapshot) -> Void in
            if self.clubNames.contains(snapshot.key){
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let club = Club()
                    club.clubName = dictionary["club_name"] as? String
                    club.clubDescription = dictionary["club_description"] as? String
//                    if !self.clubs.contains(club) {
                        self.clubs.append(club)
                        self.tableView.reloadData()
//                    }
                }
            }
        })
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClubCell", for: indexPath) as! ClubCell
        // Configure the cell...
        cell.clubNameLabel.text = clubs[indexPath.row].clubName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClub = clubs[indexPath.row]
        performSegue(withIdentifier: "toEventsList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEventsList"){
            let eventController = segue.destination as! EventsForClubTableViewController
            eventController.club = selectedClub
        }
    }
    
    func contains(club: Club) -> Bool {
        let item = clubs.filter { $0.clubName == club.clubName }
        return item.first != nil
    }
}
