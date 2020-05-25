//
//  ProposeClubViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 4/15/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RSSelectionMenu
import Firebase

class ProposeClubViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var clubNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var clubPreviewTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var clubDescriptionTextView: UITextView!
    @IBOutlet weak var clubImageView: UIImageView!
    @IBOutlet weak var pickOfficersTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var editPublishSegmentedControl: UISegmentedControl!
    @IBOutlet weak var clubNameButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    var allUsersDict = [String : String]()
    var selectedDataArray = [String]()
    var selectedIDs = [String]()
    var clubs = [Club]()
    var clubNames = [String]()
    var editClubID: String = ""
    
    let CLUBS_REF = Database.database().reference().child("clubs")
    let REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("clubs")
    let EVENT_REF = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("events")
    let EVENT_DETAILS_REF = Database.database().reference().child("events")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.clubDescriptionTextView.layer.cornerRadius = 4.0
        self.clubDescriptionTextView.layer.borderWidth = 1
        self.clubDescriptionTextView.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        
        self.clubImageView.layer.cornerRadius = 4.0
        self.clubImageView.layer.borderWidth = 1
        self.clubImageView.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        self.clubImageView.image = UIImage.init(named: "add")
        self.pickOfficersTextField.allowsEditingTextAttributes = false
        
        clubNameTextField.addDoneButtonOnKeyboard()
        clubPreviewTextField.addDoneButtonOnKeyboard()
        self.clubDescriptionTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        clubNameButton.isEnabled = false;
        clubNameTextField.isUserInteractionEnabled = true;
        clubNameTextField.text = ""
        clubPreviewTextField.text = ""
        pickOfficersTextField.text = ""
        clubDescriptionTextView.text = ""
        clubImageView.contentMode = .center
        clubImageView.image = UIImage.init(named: "add")
        
        editPublishSegmentedControl.selectedSegmentIndex = 0
        
        hideKeyboardWhenTappedAround()
        fetchUsers()
        fetchClubs()
    }
    func fetchClubs() {
        clubs = [Club]()
        clubNames = [String]()
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
                }
            }
        })
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            self.allUsersDict.updateValue(snapshot.key, forKey: (snapshot.childSnapshot(forPath: "fullname").value as? String)!)
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
            self.clubImageView.contentMode = .scaleAspectFill
            self.clubImageView.image = pickedImage
        }
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        self.openImagePickerOption()
    }
    @IBAction func clubNameButtonPressed(_ sender: Any) {
        let dataArray = clubNames
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: dataArray) { (cell, name, indexPath) in
            let club: Club = self.clubs.first(where: { $0.clubID == dataArray[indexPath.row] } ) ?? Club()
            cell.textLabel?.text = club.clubName
            cell.tintColor = .systemGreen
        }
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .present, from: self)
        
        selectionMenu.setNavigationBar(title: "Select Club to Edit", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: .systemGreen, tintColor: UIColor.white)
        selectionMenu.rightBarButtonTitle = "Submit"
        selectionMenu.leftBarButtonTitle = "Cancel"
        selectionMenu.onDismiss = { [weak self] selectedItems in
            if let id = selectedItems.first {
                let club: Club = self!.clubs.first(where: { $0.clubID == id } )!
                self?.clubNameTextField.text = club.clubName
                self?.clubPreviewTextField.text = club.clubPreview
                self?.clubDescriptionTextView.text = club.clubDescription
                self?.clubImageView.imageFromURL(urlString: club.clubImageURL!)
                self?.editClubID = id
                
                Database.database().reference().child("users").observe(.value) { (snapshot) in
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        if snap.childSnapshot(forPath: "clubs").childSnapshot(forPath: id).value as? String == "Officer" {
                            self!.selectedDataArray.append(snap.childSnapshot(forPath: "fullname").value as! String)
                        }
                    }
                    self?.pickOfficersTextField.text = self!.selectedDataArray.joined(separator: ", ")
                }
            } else {
                self?.clubNameTextField.text = ""
                self?.clubPreviewTextField.text = ""
                self?.pickOfficersTextField.text = ""
                self?.clubDescriptionTextView.text = ""
                self?.clubImageView.contentMode = .center
                self?.clubImageView.image = UIImage.init(named: "add")
            }
        }
    }
    
    @IBAction func pickOfficersButtonPressed(_ sender: Any) {
        let simpleDataArray = Array(allUsersDict.keys).sorted()
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: simpleDataArray) { (cell, name, indexPath) in

            cell.textLabel?.text = name

            // customization
            // set image
            cell.tintColor = .systemGreen
        }
        
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .present, from: self)
        
        selectionMenu.setNavigationBar(title: "Select Officers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: .systemGreen, tintColor: UIColor.white)
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
          // return filtered array based on any condition
          // here let's return array where name starts with specified search text
            return simpleDataArray.filter({ $0.lowercased().contains(searchText.lowercased()) })
        }

        // right barbutton title - Default is 'Done'
        selectionMenu.rightBarButtonTitle = "Submit"

        // left barbutton title - Default is 'Cancel'
        selectionMenu.leftBarButtonTitle = "Cancel"
        
        selectionMenu.onDismiss = { [weak self] selectedItems in
            self?.selectedDataArray = selectedItems
            self?.pickOfficersTextField.text = (self!.selectedDataArray.map{String($0)}).joined(separator: ", ")
            // perform any operation once you get selected items
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func publishButtonIsPressed(_ sender: Any) {
        var message = ""
        if clubNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            if (editPublishSegmentedControl.selectedSegmentIndex == 0) {
                message = "Please enter a club name."
            } else {
                message = "Please select a club to edit."
            }
        }else if clubPreviewTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            message = "Please enter a short club preview."
        }else if pickOfficersTextField.text?.count == 0{
            message = "Please select your club's officers."
        }else if clubDescriptionTextView.text.trimmingCharacters(in: .whitespaces).count  == 0{
            message = "Please enter a description for your club."
        }else if clubImageView.image == UIImage.init(named: "add")  {
            message = "Please select an image for your club."
        }else {
            selectedIDs = []
            for name in selectedDataArray {
                selectedIDs.append(allUsersDict[name]!)
            }
            
            if (editPublishSegmentedControl.selectedSegmentIndex == 0) {
                FIRHelperClass.sharedInstance.createClub(clubName: clubNameTextField.text!, clubPreview: clubPreviewTextField.text!, clubDescription: clubDescriptionTextView.text!, image: clubImageView.image!, officers: selectedIDs)
                message = "Club proposed successfully!"
            } else {
                FIRHelperClass.sharedInstance.editClub(clubID: editClubID, clubName: clubNameTextField.text!, clubPreview: clubPreviewTextField.text!, clubDescription: clubDescriptionTextView.text!, image: clubImageView.image!, officers: selectedIDs)
                message = "Club info successfully updated!"
            }
            
            clubNameTextField.text = ""
            clubPreviewTextField.text = ""
            pickOfficersTextField.text = ""
            clubDescriptionTextView.text = ""
            clubImageView.contentMode = .center
            clubImageView.image = UIImage.init(named: "add")
        }
        
        let alertController = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch editPublishSegmentedControl.selectedSegmentIndex {
        case 0:
            clubNameButton.isEnabled = false;
            clubNameTextField.isUserInteractionEnabled = true;
            clubNameTextField.text = ""
            clubPreviewTextField.text = ""
            pickOfficersTextField.text = ""
            clubDescriptionTextView.text = ""
            clubImageView.contentMode = .center
            clubImageView.image = UIImage.init(named: "add")
            headerLabel.text = "Propose a New Club"
            selectedDataArray = []
        case 1:
            clubNameButton.isEnabled = true;
            clubNameTextField.isUserInteractionEnabled = false;
            clubNameTextField.text = ""
            clubPreviewTextField.text = ""
            pickOfficersTextField.text = ""
            clubDescriptionTextView.text = ""
            clubImageView.contentMode = .center
            clubImageView.image = UIImage.init(named: "add")
            headerLabel.text = "Update Club Info"
            selectedDataArray = []
        default:
            break
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}
