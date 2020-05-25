//
//  ViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/28/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController{
    /*
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInButton: UIButton!
   */
    
    var isSignIn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        if isSignIn{
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
            
        } else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
  
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if isSignIn {
            //Sign In with Firebase
            Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
                if let u = user {
                    //User is found
                    self.performSegue(withIdentifier: "officerLoginSegue", sender: self)
                } else {
                    //Error: Show message
                    let alert: UIAlertController = UIAlertController(title: "Invalid Email!", message: "Please enter a valid email or sign yourself up!", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                }
            })
        } else {
            // Register With Firebase
            Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let u = user {
                    //User is found
                    self.performSegue(withIdentifier: "officerLoginSegue", sender: self)
                } else {
                    //Error: Show message
                }
            })
        }
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss keyboard
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    */
}

