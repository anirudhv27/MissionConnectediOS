//
//  AddClubsTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 3/21/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class AddClubsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var startClubLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var myClubLabel: UILabel!
    @IBOutlet weak var allClubLabel: UILabel!
    @IBOutlet weak var startClubBtn: UIButton!
    @IBOutlet weak var myClubBtn: UIButton!
    @IBOutlet weak var allClubBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var clubs: [Club] = []
    var searchedClubs: [Club] = []
    var selectedClub: Club!
    var searching = false
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    var selectedTab = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        self.topView.setShadow()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        clubs = [Club]()
        fetchClubs()
        self.myTableView.reloadData()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchClubs() {
        clubs = [Club]()
    Database.database().reference().child("schools").child(schoolName).child("clubs").observe(.childAdded, with: {(snapshot) -> Void in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let club = Club()
                club.clubName = dictionary["club_name"] as? String
                club.clubDescription = dictionary["club_description"] as? String
                club.clubImageURL = dictionary["club_image_url"] as? String
                club.clubPreview = dictionary["club_preview"] as? String
                club.numberOfMembers = dictionary["member_numbers"] as? Int
                club.clubID = snapshot.key
                if dictionary["isApproved"] as! Bool {
                    self.clubs.append(club)
                }
                self.myTableView.reloadData()
            }
        })
        print("club fetched")
    }
    
    //MARK: - UItableView Delegate and DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        cell.titleLabel.text = currClub.clubName
        cell.subTitleLabel.text = currClub.clubPreview
        REF.child(currClub.clubID!).observeSingleEvent(of: .value) { (snapshot) in
            if let str = snapshot.value as? String {
                cell.memberLabel.text = str
            } else {
                cell.memberLabel.text = "Not a Member Yet"
            }
        }
        
        cell.menuImageView.kf.setImage(with: URL(string: currClub.clubImageURL ?? ""))
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
}
