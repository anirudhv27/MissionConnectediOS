//
//  RouteViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/18/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import GoogleSignIn
class RouteViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        centerView.setShadowWithZeroSize()
        signInBtn.layer.cornerRadius = 4.0
        
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
    //    let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    //   let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
    //    self.navigationController?.pushViewController(objVC, animated: true)
     //   APPDELEGATE.gotoRouteScreen()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            print(user)
            
            FIRHelperClass.sharedInstance.isExistUser(email: user.profile.email) { (status) in
                if status{
                    let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
                    APPDELEGATE.gotoRouteScreen()
                }else {
                    let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                    objVC.user = user
                     self.navigationController?.pushViewController(objVC, animated: true)
                }
                  
            }
            
        }else {
            print(error.localizedDescription)
        }
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
