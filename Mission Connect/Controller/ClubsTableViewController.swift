//
//  ClubsTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit

class ClubsTableViewController: UITableViewController {
    
    let clubs: [Club] = [Club(clubName: "Computer Science Club", clubDescription: "A Club where we do fun Compsci Algorithms and Projects!"), Club(clubName: "AI Club", clubDescription: "Join if you want to learn more about the impacts of Artificial Intelligence and how to implement them!"), Club(clubName: "App Development Club", clubDescription: "A Club where we learn how to make apps!"), Club(clubName: "Peer Resource", clubDescription: "Subscribe to learn more about our advisory events and our various other programs!"), Club(clubName: "MSJHS 2019-2020", clubDescription: "Your place for all things MSJ, including Friday activities and other important information!"), Club(clubName: "Chess Club", clubDescription: "Learn how to out-smart and strategize against your peers! Flex your smartness!"), Club(clubName: "Medcorps", clubDescription: "Learn more abbout how to get into the medical field! Don't miss our guest speakers!"), Club(clubName: "Relay For Life", clubDescription: "Subscribe to learn about our annual event and stay informed!")]
    var selectedClub: Club!

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
        performSegue(withIdentifier: "clubDetailsSegue", sender: nil)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destinationViewController = segue.destination as! ClubDetailsViewController
        destinationViewController.club = selectedClub
    }
}

class ClubCell: UITableViewCell {
    @IBOutlet weak var clubNameLabel: UILabel!
}
