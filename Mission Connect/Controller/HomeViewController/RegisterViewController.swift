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
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
        
        var message = ""
        if schoolNameTextField.titleLabel?.text?.count == 0 {
            message = "Please enter School Name"
        } else {
            
            
           // self.uploadImageOnFirebase()
            self.sendUserDataOnFirebase()
            return
          
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
    
}


