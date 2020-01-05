//
//  EventsForClubTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/3/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import os

class EventsForClubTableViewController: UITableViewController {
    
    var data: [Event] = []
    var eventNames: [String] = []
    
    var club: Club!
    var selectedEvent: Event!
    let user = Auth.auth().currentUser
    
    let CLUB_REF = Database.database().reference().child("clubs")
    let EVENT_REF = Database.database().reference().child("events")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        fetchEvents()
    }

    // MARK: - Table view data source

    func fetchEvents() {
        var clubKey = club.clubName
        clubKey = clubKey?.lowercased().replacingOccurrences(of: " ", with: "")
        CLUB_REF.child(clubKey!).child("events").observe(.childAdded, with: { (snapshot) -> Void in
            self.eventNames.append(snapshot.key)
        })
        
        EVENT_REF.observe(.childAdded, with: { (snapshot) -> Void in
            if self.eventNames.contains(snapshot.key) {
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
        cell.eventTitleLabel.text = data[indexPath.row].event_name
        cell.clubNameLabel.text = data[indexPath.row].event_club
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = data[indexPath.row]
        performSegue(withIdentifier: "eventForClubDetals", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsController = segue.destination as! EventDetailsViewController
        detailsController.event = selectedEvent
    }
}
