//
//  HomeViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/14/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var clubNames: [String] = []
    var eventNames: [String] = []
    var clubs: [Club] = []
    var events: [Event] = []
    var goingEvents: [Event] = []
    var selectedClub: Club!
    var tab = 0
    
    var refreshControl: UIRefreshControl!
    
    var CLUBS_REF = Database.database().reference()
    var REF = Database.database().reference()
    var EVENT_REF = Database.database().reference()
    var EVENT_DETAILS_REF = Database.database().reference()
    
    //event outlet
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventBtnView: UIView!
    @IBOutlet weak var goingBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.topView.setShadow()
        self.resetButtonAtIndex(index: 1)
        self.eventBtnView.setShadow()
        clubs = [Club]()
        events = [Event]()
        goingEvents = [Event]()
        eventNames = [String]()
        closeSlider()
        myCollectionView.contentMode = .scaleAspectFill
        addRefreshControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        CLUBS_REF = Database.database().reference().child("schools").child(schoolName).child("clubs")
        REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
        EVENT_REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("events")
        EVENT_DETAILS_REF = Database.database().reference().child("schools").child(schoolName).child("events")
        
        fetchClubs()
        fetchEvents()
        eventTableView.contentSize.height = CGFloat(110 * events.count)
        myCollectionView.reloadData()
        eventTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        clubs = [Club]()
        events = [Event]()
        goingEvents = [Event]()
        eventNames = [String]()
    }
    func resetButtonAtIndex(index:Int) {
        self.allBtn.setTitleColor(.lightGray, for: .normal)
        self.goingBtn.setTitleColor(.lightGray, for: .normal)
        if index == 0 {
             self.allBtn.setTitleColor(.black, for: .normal)
            tab = 0
        }else if index == 1 {
            self.goingBtn.setTitleColor(.black, for: .normal)
            tab = 1
        }
        eventTableView.reloadData()
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
                    if (dictionary["isApproved"] as! Bool){
                        self.clubs.append(club)
                    }
                }
            }
            self.myCollectionView.reloadData()
        })
        print("club fetched in HomeViewController")
    }
    
    func fetchEvents() {
        events = [Event]()
        eventNames = [String]()
        goingEvents = [Event]()
        
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
                    event.eventPreview = dictionary["event_preview"] as? String
                    let df = DateFormatter()
                    df.dateFormat = "MM-dd-yyyy"
                    event.eventDate = df.date(from: (dictionary["event_date"] as? String)!)
                    
                    event.eventID = snapshot.key
                    event.numberOfAttendees = dictionary["member_numbers"] as? Int
                    
                    if (event.eventDate!.addingTimeInterval(86400).timeIntervalSinceNow.sign == .plus) {
                        self.events.append(event)
                        self.EVENT_REF.child("\(event.eventID ?? "")/isGoing").observeSingleEvent(of: .value, with: { (snapshot) in
                            let val = snapshot.value as? Bool
                            if val ?? false {
                                self.goingEvents.append(event)
                            }
                            self.eventTableView.reloadData()
                        })
                    }
                }
            }
            self.eventTableView.reloadData()
        })
        
        //MARK:- MUST SEE THIS IN MULTI APP TESTING
        EVENT_DETAILS_REF.observe(.childRemoved, with: { (snapshot) -> Void in
            
            if self.eventNames.contains(snapshot.key){
                
                if let dictionary = snapshot.value  as? [String: AnyObject]{
                    let event = Event()
                    event.event_club = dictionary["event_club"] as? String
                    event.event_description = dictionary["event_description"] as? String
                    event.event_name = dictionary["event_name"] as? String
                    if let img = dictionary["event_image_url"] as? String {
                        event.eventImageURL = img
                    } else {
                        event.eventImageURL = self.clubs.first { (club) -> Bool in
                            return event.event_club == club.clubID
                        }?.clubImageURL
                    }
                    let dateString = dictionary["event_date"] as? String
                    let df = DateFormatter()
                    df.dateFormat = "MM-dd-yyyy"
                    event.eventDate = df.date(from: dateString!)
                    event.eventID = snapshot.key
                    event.numberOfAttendees = dictionary["member_numbers"] as? Int
                    self.eventNames.remove(at: self.eventNames.firstIndex(of: snapshot.key)!)
                    if let index = self.events.firstIndex(of: event) {
                        self.events.remove(at: index)
                    }
                }
            }
            self.eventTableView.reloadData()
        })
        
        EVENT_DETAILS_REF.observe(.childChanged, with: { (snapshot) in
            if self.eventNames.contains(snapshot.key){
                if let dictionary = snapshot.value  as? [String: AnyObject]{
                    let event = Event()
                    event.event_club = dictionary["event_club"] as? String
                    event.event_description = dictionary["event_description"] as? String
                    event.event_name = dictionary["event_name"] as? String
                    event.eventImageURL = dictionary["event_image_url"] as? String
                    let dateString = dictionary["event_date"] as? String
                    let df = DateFormatter()
                    df.dateFormat = "MM-dd-yyyy"
                    event.eventDate = df.date(from: dateString!)
                    event.eventID = snapshot.key
                    event.numberOfAttendees = dictionary["member_numbers"] as? Int
                    
                    if (event.eventDate!.addingTimeInterval(86400).timeIntervalSinceNow.sign == .plus) {
                        let index = self.events.firstIndex { (curr_event) -> Bool in
                            return curr_event.eventID == event.eventID
                        }
                        self.events[index!] = event
                        
                        self.EVENT_REF.child("\(event.eventID ?? "")/isGoing").observeSingleEvent(of: .value, with: { (snapshot) in
                            let val = snapshot.value as? Bool
                            if val ?? false {
                                let index = self.goingEvents.firstIndex { (curr_event) -> Bool in
                                    return curr_event.eventID == event.eventID
                                }
                                self.goingEvents[index!] = event
                            }
                            self.eventTableView.reloadData()
                        })
                    }
                }
            }
            self.eventTableView.reloadData()
        })
    }
    
    @IBAction func menuBtnAction(_ sender: Any) {
        self.toggleSlider()
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
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 10.0
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = .green

        let currClub = clubs[indexPath.row]
        cell.titleLabel.text = currClub.clubName
        
        cell.imageview.kf.setImage(with: URL(string: currClub.clubImageURL ?? ""))
        cell.titleLabel.textColor = .white
        cell.imageview.sizeThatFits(CGSize.init(width: 132.0, height: 90.0))
        cell.imageview.contentMode = .scaleAspectFill
        
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
        if tab == 0 {
            if events.count == 0 {
                tableView.setEmptyView(title: "Your clubs don't have any events in the future!", message: "This area will show all of the events from clubs that you have signed up for!")
            }
            else {
                tableView.restore()
            }
            return events.count
        } else {
            if goingEvents.count == 0 {
                tableView.setEmptyView(title: "You are not going to any events!", message: "RSVP to any of your club events to have it show up here!")
            }
            else {
                tableView.restore()
            }
            return goingEvents.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        if (tab == 0){
            events.sort()
            cell.titleLabel.text = events[indexPath.row].event_name
            let df = DateFormatter()
            df.dateFormat = "MMM dd, yyyy"
            cell.subTitleLabel.text = df.string(from: events[indexPath.row].eventDate!)
            CLUBS_REF.child(events[indexPath.row].event_club!).child("club_name").observeSingleEvent(of: .value) { (snapshot) in
                let clubName = snapshot.value as? String
                cell.memberLabel.text = clubName
            }
            cell.menuImageView.kf.setImage(with: URL(string: events[indexPath.row].eventImageURL ?? ""))
    
            cell.menuImageView.sizeThatFits(CGSize.init(width: 85, height: 65))
        } else {
            goingEvents.sort()
            cell.titleLabel.text = goingEvents[indexPath.row].event_name
            let df = DateFormatter()
            df.dateFormat = "MMM dd, yyyy"
            cell.subTitleLabel.text = df.string(from: goingEvents[indexPath.row].eventDate!)
            CLUBS_REF.child(goingEvents[indexPath.row].event_club!).child("club_name").observeSingleEvent(of: .value) { (snapshot) in
                let clubName = snapshot.value as? String
                cell.memberLabel.text = clubName
            }
            cell.menuImageView.kf.setImage(with: URL(string: goingEvents[indexPath.row].eventImageURL ?? ""))
            cell.menuImageView.sizeThatFits(CGSize.init(width: 85, height: 65))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailsViewController1") as! EventDetailsViewController1
        if (tab == 0) {
            objVC.event = events[indexPath.row]
        }
        else {
            objVC.event = goingEvents[indexPath.row]
        }
        
        let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
        APPDELEGATE.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var action: UIContextualAction
        
        if (tab == 0){
            let event = events[indexPath.row]
            if goingEvents.contains(events[indexPath.row]) {
                action = UIContextualAction(style: .destructive, title: "Can't Go", handler: { (action, view, completionHandler) in
                    Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("events").child(event.eventID!).child("isGoing").setValue(false)
                    Database.database().reference().child("schools").child(schoolName).child("events").child(event.eventID!).child("member_numbers").setValue(event.numberOfAttendees! - 1)
                    
                    //self.goingEvents.remove(at: self.goingEvents.firstIndex(of: event)!)
                    self.fetchClubs()
                    self.fetchEvents()
                    self.eventTableView.contentSize.height = CGFloat(110 * self.events.count)
                    self.myCollectionView.reloadData()
                    self.eventTableView.reloadData()
                    completionHandler(true)
                })
                action.backgroundColor = .red
                
            } else {
                action = UIContextualAction(style: .normal, title: "I'm Going!", handler: { (action, view, completionHandler) in
                    Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("events").child(event.eventID!).child("isGoing").setValue(true)
                    Database.database().reference().child("schools").child(schoolName).child("events").child(event.eventID!).child("member_numbers").setValue(event.numberOfAttendees! + 1)
                    
                    //self.goingEvents.append(event)
                    self.fetchClubs()
                    self.fetchEvents()
                    self.eventTableView.contentSize.height = CGFloat(110 * self.events.count)
                    self.myCollectionView.reloadData()
                    self.eventTableView.reloadData()
                    completionHandler(true)
                })
                action.backgroundColor = .systemGreen
            }
        } else {
            let event = self.goingEvents[indexPath.row]
            action = UIContextualAction(style: .destructive, title: "Can't Go", handler: { (action, view, completionHandler) in
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("events").child(event.eventID!).child("isGoing").setValue(false)
                Database.database().reference().child("schools").child(schoolName).child("events").child(event.eventID!).child("member_numbers").setValue(event.numberOfAttendees! - 1)
    //                self.fetchClubs()
    //                self.fetchEvents()
                self.goingEvents.remove(at: indexPath.row)
                self.eventTableView.contentSize.height = CGFloat(110 * self.events.count)
                self.myCollectionView.reloadData()
                self.eventTableView.reloadData()
                completionHandler(true)
            })
            action.backgroundColor = .red
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: .allEvents)
        eventTableView.refreshControl = refreshControl
    }
    
    @objc func refreshList() {
        eventTableView.reloadData()
        myCollectionView.reloadData()
        refreshControl.endRefreshing()
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
