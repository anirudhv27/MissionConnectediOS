//
//  HomeViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/14/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var clubNames: [String] = []
    var eventNames: [String] = []
    var clubs: [Club] = []
    var events: [Event] = []
    var selectedClub: Club!
    let CLUBS_REF = Database.database().reference().child("clubs")
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    let EVENT_REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("events")
    let EVENT_DETAILS_REF = Database.database().reference().child("events")
    
    //event outlet
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventBtnView: UIView!
    @IBOutlet weak var pastBtn: UIButton!
    @IBOutlet weak var goingBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.topView.setShadow()
        self.resetButtonAtIndex(index: 0)
        self.eventBtnView.setShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchClubs()
        fetchEvents()
        eventTableView.contentSize.height = CGFloat(110 * events.count)
        myCollectionView.reloadData()
        eventTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        clubs = [Club]()
        events = [Event]()
        myCollectionView.reloadData()
        eventTableView.reloadData()
    }
    func resetButtonAtIndex(index:Int) {
        self.pastBtn.setTitleColor(.lightGray, for: .normal)
        self.allBtn.setTitleColor(.lightGray, for: .normal)
        self.goingBtn.setTitleColor(.lightGray, for: .normal)
        if index == 0 {
             self.allBtn.setTitleColor(.black, for: .normal)
        }else if index == 1 {
            self.goingBtn.setTitleColor(.black, for: .normal)
        }else {
            self.pastBtn.setTitleColor(.black, for: .normal)
        }
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
                    self.clubs.append(club)
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                    }
                }
            }
        })
        print("club fetched in HomeViewController")
    }
    
    func fetchEvents() {
        events = [Event]()
        eventNames = [String]()
        EVENT_REF.observe(.childAdded, with: { (snapshot) -> Void in
            self.eventNames.append(snapshot.key)
        })
        
        EVENT_DETAILS_REF.observe(.childAdded, with: { (snapshot) -> Void in
            if self.eventNames.contains(snapshot.key){
                if let dictionary = snapshot.value  as? [String: AnyObject]{
                    let event = Event()
                    event.event_club = dictionary["event_club"] as? String
                    event.event_description = dictionary["event_description"] as? String
                    event.event_name = dictionary["event_name"] as? String
                    event.eventImageURL = dictionary["event_image_url"] as? String
                    self.events.append(event)
                    DispatchQueue.main.async {
                        self.eventTableView.reloadData()
                    }
                }
            }
        })
        print("events fetched")
    }
    @IBAction func menuBtnAction(_ sender: Any) {
        self.toggleSlider()
    }
    
    @IBAction func pastBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 2)
    }
    @IBAction func goingBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 1)
    }
    @IBAction func allBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 0)
    }
    //MARK: - UICollectionViewDelegate and dataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelCollectionViewCell", for: indexPath) as! ImageLabelCollectionViewCell
        cell.imageview.layer.cornerRadius = 10.0
        cell.imageview.clipsToBounds = true
        
        let currClub = clubs[indexPath.row]
        cell.titleLabel.text = currClub.clubName
        cell.imageview.imageFromURL(urlString: currClub.clubImageURL ?? "")
        
        cell.imageview.sizeThatFits(CGSize.init(width: 132.0, height: 90.0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 132.0, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objvc = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "ClubsDetailsViewController") as! ClubsDetailsViewController
        objvc.club = clubs[indexPath.row]
        self.navigationController?.pushViewController(objvc, animated: true)
    }
    
    //MARK: - UItableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        cell.titleLabel.text = events[indexPath.row].event_name
        cell.subTitleLabel.text = events[indexPath.row].event_description
        CLUBS_REF.child(events[indexPath.row].event_club!).child("club_name").observeSingleEvent(of: .value) { (snapshot) in
            let clubName = snapshot.value as? String
            cell.memberLabel.text = clubName
        }
        cell.menuImageView.imageFromURL(urlString: events[indexPath.row].eventImageURL ?? "")
 
        cell.menuImageView.sizeThatFits(CGSize.init(width: 85, height: 65))
        print(events[indexPath.row].event_name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailsViewController1") as! EventDetailsViewController1
        objVC.event = events[indexPath.row]
        let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
        APPDELEGATE.navigationController?.pushViewController(objVC, animated: true)
    }

}

extension UIView {
    func setShadow() {
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1,height: 1)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0.0
        
    }
    
    func setShadowWithZeroSize() {
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset =  CGSize.zero
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 35.0
        
    }
}
