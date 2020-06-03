//
//  ApproveClubsListViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 4/18/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ApproveClubsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var clubs: [Club] = []
    var searchedClubs: [Club] = []
    var selectedClub: Club!
    var searching = false
    
    var refreshControl: UIRefreshControl!
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        myTableView.delegate = self
        myTableView.dataSource = self
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        clubs = [Club]()
        fetchClubs()
        self.myTableView.reloadData()
    }
    
    func fetchClubs() {
        clubs = [Club]()
        Database.database().reference().child("clubs").observe(.childAdded, with: {(snapshot) -> Void in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let club = Club()
                    club.clubName = dictionary["club_name"] as? String
                    club.clubDescription = dictionary["club_description"] as? String
                    club.clubImageURL = dictionary["club_image_url"] as? String
                    club.clubPreview = dictionary["club_preview"] as? String
                    club.numberOfMembers = dictionary["member_numbers"] as? Int
                    club.clubID = snapshot.key
                    if (dictionary["isApproved"] as! Bool) == false {
                        self.clubs.append(club)
                    }
                    self.myTableView.reloadData()
                }
            })
            print("club fetched")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedClubs.count
        } else {
            return clubs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        var currClub: Club!
        if searching {
            currClub = searchedClubs[indexPath.row]
        } else {
            currClub = clubs[indexPath.row]
        }
        cell.subTitleLabel.text = currClub.clubName
        cell.memberLabel.text = currClub.clubPreview
        cell.menuImageView.kf.setImage(with: URL(string: currClub.clubImageURL ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let approve = UIContextualAction(style: .normal, title: "Approve") { (action, view, completion) in
            if self.searching {
                let club = self.clubs.remove(at: indexPath.row)
                Database.database().reference().child("clubs").child(club.clubID!).child("isApproved").setValue(true)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let club = self.clubs.remove(at: indexPath.row)
                Database.database().reference().child("clubs").child(club.clubID!).child("isApproved").setValue(true)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            completion(true)
        }
        approve.backgroundColor = .systemGreen
        
        let delete = UIContextualAction(style: .destructive, title: "Reject") { (action, view, completion) in
            if self.searching {
                let club = self.searchedClubs.remove(at: indexPath.row)
                self.clubs.remove(at: self.clubs.firstIndex(of: club)!)
                tableView.deleteRows(at: [indexPath], with: .fade)
                Database.database().reference().child("clubs").child(club.clubID!).removeValue()
                Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
                    if snapshot.childSnapshot(forPath: "clubs").hasChild(club.clubID!){
                        Database.database().reference().child("users").child(snapshot.key).child("clubs").child(club.clubID!).removeValue()
                    }
                }
            } else {
                let club = self.clubs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                Database.database().reference().child("clubs").child(club.clubID!).removeValue()
                Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
                    if snapshot.childSnapshot(forPath: "clubs").hasChild(club.clubID!){
                        Database.database().reference().child("users").child(snapshot.key).child("clubs").child(club.clubID!).removeValue()
                    }
                }
            }
            
        }
        delete.backgroundColor = .red
        let swipeAction = UISwipeActionsConfiguration(actions: [approve, delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: .allEvents)
        myTableView.refreshControl = refreshControl
    }
    
    @objc func refreshList() {
        fetchClubs()
        refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchedClubs = clubs.filter({ $0.clubName!.lowercased().contains(searchText.lowercased()) })
        myTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.view.endEditing(true)
        myTableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
