//
//  PublishViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/16/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField


class PublishViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clubNametextField: UITextField!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventStartDateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventEnddatetextField: SkyFloatingLabelTextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var allEventBtn: UIButton!
    @IBOutlet weak var addEventBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var enddateBtn: UIButton!
    
    //event outlet
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var topTableView: UITableView!
    
    var currEventID: String = ""
    
    let CLUBS_REF = Database.database().reference().child("clubs")
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    let EVENT_REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("events")
    let EVENT_DETAILS_REF = Database.database().reference().child("events")
    var clubs: [Club] = []
    var events: [Event] = []
    let user = Auth.auth().currentUser
    var clubNames: [String] = []
    var eventNames: [String] = []
    
    var isFromStartDate = true
    var currClubID: String = ""
    
    var isFromEdit = false
    
    var currDate: Date = Date()
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.descriptionTextView.layer.cornerRadius = 4.0
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        
        self.eventImageView.layer.cornerRadius = 4.0
        self.eventImageView.layer.borderWidth = 1
        self.eventImageView.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        self.eventImageView.image = UIImage.init(named: "add")
        
       
        datePickerView.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        dateBtn.setTitle("", for: .normal)
        eventView.isHidden = true
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        clubs = [Club]()
        events = [Event]()
        fetchClubs()
        fetchEvents()
    }
    
    func fetchClubs() {
        clubs = [Club]()
        clubNames = [String]()
        eventNames = [String]()
        REF.observe(.childAdded, with: { (snapshot) -> Void in
            if (snapshot.value as? String == "Officer"){
                self.clubNames.append(snapshot.key)
            }
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
                    self.myCollectionView.reloadData()
                }
            }
        })
    }
    
    func fetchEvents() {
        events = [Event]()
        eventNames = [String]()
        EVENT_REF.observe(.childAdded, with: { (snapshot) -> Void in
            if (snapshot.childSnapshot(forPath: "member_status").value as? String == "Officer") {
                self.eventNames.append(snapshot.key)
            }
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
                    let dateString = dictionary["event_date"] as? String
                    self.df.dateFormat = "MM-dd-yyyy"
                    event.eventDate = self.df.date(from: dateString!)
                    event.eventID = snapshot.key
                    event.numberOfAttendees = dictionary["member_numbers"] as? Int
                    self.events.append(event)
                    self.eventTableView.reloadData()
                }
            }
        })
        
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
                    self.df.dateFormat = "MM-dd-yyyy"
                    event.eventDate = self.df.date(from: dateString!)
                    event.eventID = snapshot.key
                    let index = self.events.firstIndex(of: event)
                    self.events.remove(at: index!)
                    self.eventTableView.reloadData()
                }
            }
        })
        
        EVENT_DETAILS_REF.observe(.childChanged, with: { (snapshot) -> Void in
            if self.eventNames.contains(snapshot.key){
                if let dictionary = snapshot.value  as? [String: AnyObject]{
                    let event = Event()
                    event.event_club = dictionary["event_club"] as? String
                    event.event_description = dictionary["event_description"] as? String
                    event.event_name = dictionary["event_name"] as? String
                    event.eventImageURL = dictionary["event_image_url"] as? String
                    let dateString = dictionary["event_date"] as? String
                    self.df.dateFormat = "MM-dd-yyyy"
                    event.eventDate = self.df.date(from: dateString!)
                    event.eventID = snapshot.key
                    let index = self.events.firstIndex { (curr_event) -> Bool in
                        return curr_event.eventID == event.eventID
                    }
                    self.events[index!] = event
                    self.eventTableView.reloadData()
                }
            }
        })
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            eventStartDateTextField.text = "\(Calendar.current.monthSymbols[month - 1]) \(day), \(year)"
            currDate = Calendar.current.date(from: components)!
        }
    }
    
    //MARK:- ImagePickerMethods
    func openImagePickerOption(){
        
        self.view.endEditing(true)
        
        let myActionSheet = UIAlertController()
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cmaeraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cmaeraAction)
        myActionSheet.addAction(cancelAction)
       
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func openCamera(){
        
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))  {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Camera is not supported", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func openGallary() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true //2
        imagePicker.sourceType = .photoLibrary //3
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let pickedImage: UIImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) {
            self.eventImageView.contentMode = .scaleAspectFill
            self.eventImageView.image = pickedImage
        }
    }
    
    @IBAction func imageBtnAction(_ sender: Any) {
        self.openImagePickerOption()
    }
    
    @IBAction func enddateBtnAction(_ sender: Any) {
        self.isFromStartDate = false
        self.datePickerView.isHidden = false
        self.view.endEditing(true)
    }
    @IBAction func dateBtn(_ sender: Any) {
        self.isFromStartDate = true
        self.datePickerView.isHidden = false
        self.view.endEditing(true)
    }
    @IBAction func allEventBtnAction(_ sender: Any) {
        allEventBtn.setTitleColor(.black, for: .normal)
         addEventBtn.setTitleColor(.darkGray, for: .normal)
        self.topTableView.isScrollEnabled = false
        self.eventView.isHidden = false
    }
    @IBAction func addEventBtnAction(_ sender: Any) {
        addEventBtn.setTitleColor(.black, for: .normal)
        allEventBtn.setTitleColor(.darkGray, for: .normal)
        self.topTableView.isScrollEnabled = true
        self.eventView.isHidden = true
    }
    
    @IBAction func publishBtnAction(_ sender: Any) {
        
        var message = ""
        if clubNametextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            message = "Please select a Club."
        }else if eventNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            message = "Please enter an EVENT NAME."
        }else if eventStartDateTextField.text?.count == 0 {
            message = "Please select an EVENT DATE."
        }else if eventEnddatetextField.text?.count == 0{
            message = "Please enter an EVENT PREVIEW."
        }else if descriptionTextView.text.trimmingCharacters(in: .whitespaces).count  == 0{
            message = "Please enter an EVENT DESCRIPTION."
        }else if eventImageView.image == UIImage.init(named: "add")  {
            message = "Please enter an EVENT IMAGE."
        }else {
            if isFromEdit{
                FIRHelperClass.sharedInstance.editEvent(startDate: currDate, eventName: eventNameTextField.text!, clubName: currClubID, eventDescription: descriptionTextView.text!, image: eventImageView.image!, preview: eventEnddatetextField.text!, key: currEventID)
                message = "Event updated successfully."
            } else {
                FIRHelperClass.sharedInstance.createEvent(startDate: currDate, eventName: eventNameTextField.text!, clubName: currClubID, eventDescription: descriptionTextView.text!, image: eventImageView.image!, preview: eventEnddatetextField.text!)
                message = "Event published successfully."
            }
            clubNametextField.text = ""
            eventNameTextField.text = ""
            dateBtn.setTitle("", for: .normal)
            descriptionTextView.text = ""
            eventImageView.contentMode = .center
            eventImageView.image = UIImage.init(named: "add")
            allEventBtn.setTitleColor(.black, for: .normal)
            addEventBtn.setTitleColor(.darkGray, for: .normal)
            eventStartDateTextField.text = ""
            eventEnddatetextField.text = ""
            currDate = Date()
            self.currClubID = ""
            topTableView.contentOffset = CGPoint(x: 0, y: -topTableView.contentInset.top)
            self.topTableView.isScrollEnabled = false
            self.eventView.isHidden = false
        }
        
        let alertController = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            self.eventTableView.reloadData()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func dateBtnAction(_ sender: Any) {
        self.datePickerView.isHidden = true
        self.view.endEditing(true)
    }
    //MARK: - UICollectionViewDelegate and dataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelCollectionViewCell", for: indexPath) as! ImageLabelCollectionViewCell
        let currClub = clubs[indexPath.row]
        cell.imageview.layer.cornerRadius = 10.0
        cell.imageview.clipsToBounds = true
        cell.titleLabel.text = currClub.clubName
        cell.imageview.sizeThatFits(CGSize.init(width: 132.0, height: 90.0))
        cell.imageview.imageFromURL(urlString: currClub.clubImageURL ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 132.0, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clubNametextField.text = clubs[indexPath.row].clubName
        let cell = myCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.systemGreen.cgColor
        cell?.layer.cornerRadius = 10.0
        self.currClubID = clubs[indexPath.row].clubID!
        self.eventImageView.imageFromURL(urlString: clubs[indexPath.row].clubImageURL!)
        self.eventImageView.contentMode = .scaleAspectFill
        isFromEdit = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = myCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
    
    //MARK: - UItableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        events.sort()
        let event = events[indexPath.row]
        df.dateFormat = "MMM dd, yyyy"
        cell.titleLabel.text = df.string(from: event.eventDate ?? Date())
        cell.subTitleLabel.text = event.event_name
        CLUBS_REF.child(event.event_club!).child("club_name").observeSingleEvent(of: .value) { (snapshot) in
            let clubName = snapshot.value as? String
            cell.memberLabel.text = clubName
        }
        
        cell.menuImageView.imageFromURL(urlString: event.eventImageURL ?? "")
        cell.editBtn.layer.cornerRadius = 4.0
        cell.deleteBtn.layer.cornerRadius = 4.0
        cell.editBtn.addTarget(self, action: #selector(self.editEventBtnAction(sender:)), for: .touchUpInside)
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteEventBtnAction(sender:)), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        return cell
    }
    
    @objc func editEventBtnAction(sender: UIButton) {
        let event: Event = events[sender.tag]
        self.eventView.isHidden = true
        CLUBS_REF.child(event.event_club!).child("club_name").observeSingleEvent(of: .value) { (snapshot) in
            let clubName = snapshot.value as? String
            self.clubNametextField.text = clubName
        }
        
        eventNameTextField.text = event.event_name
        dateBtn.setTitle("", for: .normal)
        //enddateBtn.setTitle("", for: .normal)
        descriptionTextView.text = ""
        eventImageView.contentMode = .center
        eventImageView.image = UIImage.init(named: "add")
        allEventBtn.setTitleColor(.darkGray, for: .normal)
        addEventBtn.setTitleColor(.black, for: .normal)
        currEventID = event.eventID!
        currClubID = event.event_club!
        self.topTableView.isScrollEnabled = true
        isFromEdit = true
    }
    
    @objc func deleteEventBtnAction(sender: UIButton) {
        let alertController = UIAlertController.init(title: "Delete!", message: "Event deleted successfully.", preferredStyle: .alert)
        let event: Event = self.events[sender.tag]
        self.CLUBS_REF.child(event.event_club!).child("events").child(event.eventID!).removeValue()
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            snapshot.childSnapshot(forPath: "events").childSnapshot(forPath: event.eventID!).ref.removeValue()
        }
        Database.database().reference().child("events").child(event.eventID!).removeValue()
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            self.eventTableView.reloadData()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailsViewController1") as! EventDetailsViewController1
        objVC.isOfficer = true
        objVC.event = events[indexPath.row]
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    private func scrollToTop() {
        if topTableView.numberOfRows(inSection: 0) != 0 {
            topTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        self.eventTableView.reloadData()
    }
}
