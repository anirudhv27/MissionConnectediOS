//
//  EventListTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 3/22/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class EventListTableViewController: UITableViewController {
    
    var events: [Event] = []
    var eventNames: [String] = []
    var club: Club!
    @IBOutlet weak var topLabel: UILabel!
    
    let EVENTS_REF = Database.database().reference().child("events")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEvents()
        topLabel.text = "\(club.clubName ?? "All") Events"
    }
    
    func fetchEvents() {
        events = [Event]()
        eventNames = [String]()
        EVENTS_REF.observe(.childAdded) { (snapshot) -> Void in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if dictionary["event_club"] as? String == self.club.clubID {
                    let event = Event()
                    event.event_name = dictionary["event_name"] as? String
                    event.event_description = dictionary["event_description"] as? String
                    event.eventImageURL = dictionary["event_image_url"] as? String
                    event.event_club = self.club.clubName
                    self.events.append(event)
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        cell.menuImageView.imageFromURL(urlString: events[indexPath.row].eventImageURL ?? "")
        cell.subTitleLabel.text = events[indexPath.row].event_name
        cell.memberLabel.text = events[indexPath.row].event_description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailsViewController1") as! EventDetailsViewController1
        objVC.event = events[indexPath.row]
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
