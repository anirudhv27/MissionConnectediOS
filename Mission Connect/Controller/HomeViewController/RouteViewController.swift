//
//  RouteViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/18/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class RouteViewController: UIViewController {
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        centerView.setShadowWithZeroSize()
        signInButton.layer.cornerRadius = 4.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
