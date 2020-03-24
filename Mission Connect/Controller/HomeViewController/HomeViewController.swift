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
    @IBOutlet weak var pastLabel: UILabel!
    @IBOutlet weak var goingLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
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
        self.pastLabel.isHidden = true
        self.allLabel.isHidden = true
        self.goingLabel.isHidden = true
        if index == 0 {
             self.allBtn.setTitleColor(.black, for: .normal)
            self.allLabel.isHidden = false
        }else if index == 1 {
            self.goingBtn.setTitleColor(.black, for: .normal)
            self.goingLabel.isHidden = false
        }else {
            self.pastBtn.setTitleColor(.black, for: .normal)
            self.pastLabel.isHidden = false
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
                    club.clubID = snapshot.key
                    //                    if !self.clubs.contains(club) {
                    self.clubs.append(club)
                    self.myCollectionView.reloadData()
                }
            }
        })
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
                    self.events.append(event)
                    self.eventTableView.reloadData()
                }
            }
        })
        
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
    @IBAction func seeAllClubBtnAction(_ sender: Any) {
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClubViewController") as! ClubViewController
        objVC.isFromClubsTab = false
        self.navigationController?.pushViewController(objVC, animated: true)
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
        if let url = URL(string: currClub.clubImageURL!){
            do {
                let data = try Data(contentsOf: url)
                cell.imageview.image = UIImage(data: data)
            } catch let err{
                print(err)
            }
        }
        
        // cell.menuImageView.sd_setImage(with: imgRef, placeholderImage: placeholderImage)
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 120.0, height: 138)
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
        
        cell.menuImageView.image = UIImage.init(named: "event")
        cell.titleLabel.text = events[indexPath.row].event_name
        cell.subTitleLabel.text = events[indexPath.row].event_description
        cell.memberLabel.text = events[indexPath.row].event_club
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailsViewController1") as! EventDetailsViewController1
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
