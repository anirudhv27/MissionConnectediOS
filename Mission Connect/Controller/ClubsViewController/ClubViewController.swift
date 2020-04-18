//
//  ClubViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 12/22/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var clubNames: [String] = []
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
    let CLUBS_REF = Database.database().reference().child("clubs")
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    
    var clubs: [Club] = []
    var searchedClubs: [Club] = []
    var searching = false
    
    var selectedClub: Club!
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    
    var selectedTab = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        self.topView.setShadow()
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
        clubNames = [String]()
        REF.observe(.childAdded, with: { (snapshot) -> Void in
            self.clubNames.append(snapshot.key)
        })
        
        CLUBS_REF.observe(.childAdded, with: { (snapshot) -> Void in
            if self.clubNames.contains(snapshot.key){
                if let dictionary = snapshot.value  as? [String: AnyObject]{
                    let club = Club()
                    club.clubName = dictionary["club_name"] as? String
                    club.clubDescription = dictionary["club_description"] as? String
                    club.clubImageURL = dictionary["club_image_url"] as? String
                    club.clubPreview = dictionary["club_preview"] as? String
                    club.numberOfMembers = dictionary["member_numbers"] as? Int
                    club.clubID = snapshot.key
                    //                    if !self.clubs.contains(club) {
                    if dictionary["isApproved"] as! Bool{
                        self.clubs.append(club)
                    }
                    self.myTableView.reloadData()
                }
            }
        })
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
        clubs.sort()
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
            cell.memberLabel.text = snapshot.value as? String
        }
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
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addClubSegue", sender: self)
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
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
