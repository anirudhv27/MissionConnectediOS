//
//  ViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/28/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if (usernameTextField.text == "anivalstudent@fusdk12.net" && passwordTextField.text == "password123"){
            self.performSegue(withIdentifier: "studentLoginSegue", sender: self)
        } else if (usernameTextField.text == "anivalofficer@fusdk12.net" && passwordTextField.text == "password123") {
            self.performSegue(withIdentifier: "officerLoginSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Invalid Username or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func signUputtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Sorry!", message: "Sign-up Functionality still in development!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

