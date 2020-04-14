//
//  AddClubsTableViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 3/21/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class AddClubsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var startClubLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var myClubLabel: UILabel!
    @IBOutlet weak var allClubLabel: UILabel!
    @IBOutlet weak var startClubBtn: UIButton!
    @IBOutlet weak var myClubBtn: UIButton!
    @IBOutlet weak var allClubBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    
    
    var clubs: [Club] = []
    var selectedClub: Club!
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    var selectedTab = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.topView.setShadow()
        myTableView.delegate = self
        myTableView.dataSource = self
        fetchClubs()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                self.clubs.append(club)
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
        return clubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        
        let currClub = clubs[indexPath.row]
        cell.titleLabel.text = currClub.clubName
        cell.subTitleLabel.text = currClub.clubPreview
        REF.child(currClub.clubID!).observeSingleEvent(of: .value) { (snapshot) in
            if let str = snapshot.value as? String {
                cell.memberLabel.text = str
            } else {
                cell.memberLabel.text = "Not a Member Yet"
            }
        }
        
        cell.menuImageView.imageFromURL(urlString: currClub.clubImageURL ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objvc = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "ClubsDetailsViewController") as! ClubsDetailsViewController
        objvc.club = clubs[indexPath.row]
        print(objvc.club.clubDescription)
               self.navigationController?.pushViewController(objvc, animated: true)
    }
}
