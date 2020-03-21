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

class ClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    var isFromSideMenu = false
    var selectedTab = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.topView.setShadow()
        self.resetButtonAtIndex(index: 0)
        if isFromSideMenu == false {
            self.backBtn.isHidden = true
        }
        fetchClubs()
    }
    
    func resetButtonAtIndex(index: Int) {
        self.allClubBtn.setTitleColor(.lightGray, for: .normal)
        self.myClubBtn.setTitleColor(.lightGray, for: .normal)
    
        self.allClubLabel.isHidden = true
        self.myClubLabel.isHidden = true
    
        
        if index == 0{
            self.allClubBtn.setTitleColor(.black, for: .normal)
            self.allClubLabel.isHidden = false
        }else if index == 1 {
            self.myClubBtn.setTitleColor(.black, for: .normal)
            self.myClubLabel.isHidden = false
        }else {
            
        }
        self.selectedTab = index
    }
    
    @IBAction func startClubBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 2)
    }
    @IBAction func myClubBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 1)
    }
    @IBAction func allClubBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 0)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchClubs() {
        Database.database().reference().child("clubs").observe(.childAdded, with: {(snapshot) -> Void in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let club = Club()
                club.clubName = dictionary["club_name"] as? String
                club.clubDescription = dictionary["club_description"] as? String
                club.clubImageURL = dictionary["club_image_url"] as? String
                club.clubID = snapshot.key
                self.clubs.append(club)
                self.myTableView.reloadData()
            }
        })
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
        cell.subTitleLabel.text = "Club SubTitle"
        cell.memberLabel.text = "Member Status"
        let imgRef = storageRef.child("clubimages/\(String(describing: currClub.clubImageURL))")
        let placeholderImage = UIImage(named: "event")
       // cell.menuImageView.sd_setImage(with: imgRef, placeholderImage: placeholderImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objvc = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "ClubsDetailsViewController") as! ClubsDetailsViewController
        objvc.club = clubs[indexPath.row]
        print(objvc.club.clubDescription)
               self.navigationController?.pushViewController(objvc, animated: true)
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
