//
//  ApproveClubsListViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 4/18/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class ApproveClubsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var clubs: [Club] = []
    var searchedClubs: [Club] = []
    var selectedClub: Club!
    var searching = false
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        myTableView.delegate = self
        myTableView.dataSource = self
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
        cell.menuImageView.imageFromURL(urlString: currClub.clubImageURL ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objvc = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "ClubsDetailsViewController") as! ClubsDetailsViewController
        if searching {
            objvc.club = searchedClubs[indexPath.row]
        } else {
            objvc.club = clubs[indexPath.row]
        }
               self.navigationController?.pushViewController(objvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let approve = UITableViewRowAction(style: .normal, title: "Approve?") { (action, index) in
            if self.searching {
                let club = self.clubs.remove(at: index.row)
                Database.database().reference().child("clubs").child(club.clubID!).child("isApproved").setValue(true)
                
                tableView.deleteRows(at: [index], with: .fade)
            } else {
                let club = self.clubs.remove(at: index.row)
                Database.database().reference().child("clubs").child(club.clubID!).child("isApproved").setValue(true)
                tableView.deleteRows(at: [index], with: .fade)
            }
        }
        approve.backgroundColor = .systemGreen
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            if self.searching {
                let club = self.searchedClubs.remove(at: index.row)
                self.clubs.remove(at: self.clubs.firstIndex(of: club)!)
                tableView.deleteRows(at: [index], with: .fade)
                Database.database().reference().child("clubs").child(club.clubID!).removeValue()
                Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
                    if snapshot.childSnapshot(forPath: "clubs").hasChild(club.clubID!){
                        Database.database().reference().child("users").child(snapshot.key).child("clubs").child(club.clubID!).removeValue()
                    }
                }
            } else {
                let club = self.clubs.remove(at: index.row)
                tableView.deleteRows(at: [index], with: .fade)
                Database.database().reference().child("clubs").child(club.clubID!).removeValue()
                Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
                    if snapshot.childSnapshot(forPath: "clubs").hasChild(club.clubID!){
                        Database.database().reference().child("users").child(snapshot.key).child("clubs").child(club.clubID!).removeValue()
                    }
                }
            }
        }
        delete.backgroundColor = .red
        return [approve, delete]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchedClubs = clubs.filter({String(($0.clubName?.prefix(searchText.count))!).lowercased() == searchText.lowercased()})
        myTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        myTableView.reloadData()
    }
    
}
