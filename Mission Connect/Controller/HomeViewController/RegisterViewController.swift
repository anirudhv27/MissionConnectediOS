//
//  RegisterViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/19/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
import Firebase
import RSSelectionMenu

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var schoolNameTextField: SkyFloatingLabelTextField!
    
    var user : GIDGoogleUser!
    var id: String!
    var email: String!
    var fullname: String!
    var imgurl: String!
    
    var schoolDict = [String: String]()
    var ref: DatabaseReference!
    var selectedNames = [String]()
    
    var domains = [String]()
    var specialUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchSchools()
    }
    
    func fetchSchools() {
        ref.child("schools").observe(.childAdded) { (snapshot) in
            self.schoolDict.updateValue(snapshot.key , forKey: snapshot.childSnapshot(forPath: "school_name").value as! String)
        }
    }
    
    @IBAction func schoolNameTextFieldBtnAction(_ sender: Any) {
        domains = []
        specialUsers = []
        let dataArray = Array(schoolDict.keys).sorted()
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: dataArray) { (cell, name, indexPath) in
            cell.textLabel?.text = name
            cell.tintColor = .systemGreen
        }
        
        selectionMenu.cellSelectionStyle = .checkbox
        
        selectionMenu.setSelectedItems(items: selectedNames) { [weak self] (item, index, isSelected, selectedItems) in

            // update your existing array with updated selected items, so when menu show menu next time, updated items will be default selected.
            self?.selectedNames = selectedItems
        }
        
        selectionMenu.show(style: .popover(sourceView: schoolNameTextField, size: nil), from: self)
        selectionMenu.onDismiss = { [weak self] selectedItems in
            if let name = selectedItems.first {
                self?.schoolNameTextField.text = name
                self!.ref.child("schools").child(self!.schoolDict[name]!).observeSingleEvent(of: .value) { (snapshot) in
                    self!.domains = snapshot.childSnapshot(forPath: "domains").value as! [String]
                    self!.specialUsers = snapshot.childSnapshot(forPath: "special_users").value as! [String]
                }
            }
        }
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
        
        var message = ""
        if schoolNameTextField.titleLabel?.text?.count == 0 {
            message = "Please enter School Name"
        } else {
            if domains.contains(String(email.split(separator: "@")[1])) || specialUsers.contains(email) {
                self.sendUserDataOnFirebase()
                return
            } else {
                message = "Invalid email for this school. Please login with a different email or pick a different school."
            }
        }
        
        let alertController = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendUserDataOnFirebase() {
       // let imageURL = uploadImageOnFirebase()
        let schoolID = schoolDict[self.schoolNameTextField.text!]!
        
        FIRHelperClass.sharedInstance.saveUserData(emailString: email, fullName: fullname, school: schoolID, imgURL: imgurl, id: id)
        
        let alertController = UIAlertController.init(title: "Alert", message: "You have successfully registered.", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            schoolName = self.schoolNameTextField.text!
            let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
            APPDELEGATE.gotoRouteScreen()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        let alert = UIAlertController.init(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Yes", style: .default) { (action) in
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let defaults = UserDefaults.standard
                defaults.set(false, forKey: "isUserSignedIn")
                GIDSignIn.sharedInstance()?.signOut()
                GIDSignIn.sharedInstance()?.disconnect()
              
                let storyboard = UIStoryboard(name: "Other", bundle: nil)
                let initial = storyboard.instantiateInitialViewController()
                self.navigationController?.popToRootViewController(animated: true)
                UIApplication.shared.keyWindow?.rootViewController = initial
                
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
        
        let noAction = UIAlertAction.init(title: "No", style: .cancel) { (action) in
            
        }
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}


