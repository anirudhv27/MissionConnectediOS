//
//  DashboardTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class DashboardTableViewController: UITableViewController {
    var data: [Event] = []
    var events: [String] = []
    var clubs: [String] = []
    
    var selectedEvent: Event!
    let user = Auth.auth().currentUser
    
    //Properties
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        fetchEvents()
        
    }
    
    func fetchEvents() {
        Database.database().reference().child("users").child(user!.uid).child("clubs").observe(.childAdded, with: {(snapshot) -> Void in
            self.clubs.append(snapshot.key)
        })
        
        Database.database().reference().child("clubs").observe(.childAdded, with: {(snapshot) -> Void in
            if self.clubs.contains(snapshot.key){
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.events += Array((dictionary["events"]?.allKeys)!) as! [String]
                }
            }
        })
        
        Database.database().reference().child("events").observe(.childAdded, with: { (snapshot) -> Void in
            if self.events.contains(snapshot.key) {
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    let event = Event()
                    event.event_club = dictionary["event_club"] as? String
                    event.event_description = dictionary["event_description"] as? String
                    event.event_name = dictionary["event_name"] as? String
                    self.data.append(event)
                    self.tableView.reloadData()
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
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! AnnouncementCell
        // Configure the cell...
        cell.eventTitleLabel.text = data[indexPath.row].event_name
        cell.clubNameLabel.text = data[indexPath.row].event_club
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedEvent = data[indexPath.row]
        performSegue(withIdentifier: "eventDetailSegue", sender: nil)
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsController = segue.destination as! EventDetailsViewController
        detailsController.event = selectedEvent
    }
}

class AnnouncementCell: UITableViewCell {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
}
