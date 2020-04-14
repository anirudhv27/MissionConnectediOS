//
//  RegisterViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/19/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
import FirebaseStorage
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var graduationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var schoolNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fullNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nickNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    var user : GIDGoogleUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
      //  graduationTextField.addto
        self.addToolBar(textField: graduationTextField)
        fullNameTextField.text = user.profile.name
        
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
                self .present(imagePicker, animated: true, completion: nil)
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
        
        if  let pickedImage: UIImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) {
            //self.eventImageView.contentMode = .scaleAspectFill
            self.profileImageView.image = pickedImage
        }
    }
    
    func addToolBar(textField: UITextField) {
           let toolBar = UIToolbar()
           toolBar.barStyle = .default
           toolBar.isTranslucent = true
           toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
           let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)


           toolBar.isUserInteractionEnabled = true
           toolBar.sizeToFit()

           textField.delegate = self
           textField.inputAccessoryView = toolBar
       }

       @objc func donePressed() {
           view.endEditing(true)
       }

       @objc func cancelPressed() {
           view.endEditing(true) // or do something
       }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == graduationTextField  || textField == schoolNameTextField{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         self.view.frame.origin.y = 0
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textfield - \(textField.text)  string-\(string)")
    
        if textField == graduationTextField {
            let yearString = "\(textField.text ?? "")\(string)"
            if yearString.count > 0 {
                let yearInt  = Int(yearString)!
                if yearInt > 2025 {
                    return false
                }else {
                    return true
                }
            }else {
                 return true
            }
        }
        
        return true
    }
    
    @IBAction func profileImageBtnAction(_ sender: Any) {
        self.openImagePickerOption()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
        
        var message = ""
        if nickNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            message = "Please enter Nickname"
        }else if fullNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            message = "Please enter Fullname"
        }else if schoolNameTextField.titleLabel?.text?.count == 0 {
            message = "Please enter School Name"
        }else if graduationTextField.titleLabel?.text?.count == 0{
            message = "Please enter Graduation Year"
        }else {
            
            
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
         let imageURL = "uploadImageOnFirebase"
        FIRHelperClass.sharedInstance.saveUserData(emailString: self.user.profile.email, nickName: self.nickNameTextField.text!, fullName: self.fullNameTextField.text!, graduationYear: self.graduationTextField.text!, schoolName: self.schoolNameTextField.text!, imageURL: imageURL)
        let alertController = UIAlertController.init(title: "Alert", message: "You have successfully registered.", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            APPDELEGATE.gotoRouteScreen()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func uploadImageOnFirebase() -> String {
        FIRHelperClass.sharedInstance.updateProfileImage(image: self.profileImageView.image!) { (status, imageURL) in
            if status == true {
                //self.sendUserDataOnFirebase(imageURL: "\(imageURL!)")
                print ("status=True, uploadImageOnFirebase")
            }
            else {
                print ("status= False , uploadImageOnFirebase")
            }
        }
        return "uploadImageOnFirebase"
    }
    
}


