//
//  DashboardTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController {
    
    let data: [Event] = [Event(eventTitle: "Anouncement 1", clubName: "Club A", eventDescription: "a club"), Event(eventTitle: "Anouncement 2", clubName: "Club B", eventDescription: "a club"), Event(eventTitle: "Anouncement 3", clubName: "Club C", eventDescription: "a club"), Event(eventTitle: "Anouncement 4", clubName: "Club D", eventDescription: "a club"), Event(eventTitle: "Anouncement 5", clubName: "Club E", eventDescription: "a club"), Event(eventTitle: "Anouncement 6", clubName: "Club F", eventDescription: "a club"), Event(eventTitle: "Anouncement 7", clubName: "Club G", eventDescription: "a club"), Event(eventTitle: "Anouncement 8", clubName: "Club H", eventDescription: "a club"), Event(eventTitle: "Anouncement 9", clubName: "Club I", eventDescription: "a club"), Event(eventTitle: "Anouncement 10", clubName: "Club J", eventDescription: "a club"), Event(eventTitle: "Anouncement 11", clubName: "Club K", eventDescription: "a club"), Event(eventTitle: "Anouncement 12", clubName: "Club L", eventDescription: "a club"), Event(eventTitle: "Anouncement 13", clubName: "Club M", eventDescription: "a club")]
    var selectedEvent: Event!
    
    //Properties
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.eventTitleLabel.text = data[indexPath.row].eventTitle
        cell.clubNameLabel.text = data[indexPath.row].clubName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedEvent = data[indexPath.row]
        performSegue(withIdentifier: "eventDetailSegue", sender: nil)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
