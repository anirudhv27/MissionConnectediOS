//
//  SideMenuViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/14/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import Kingfisher

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    
    var menuList = [String]()
    var imageList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuList = ["Dashboard","Clubs","Publish","Support","Privacy Policy", "Version 1.0", "LogOut"]
        imageList = ["home","clubs","share", "support","privacypolicy", "version","logout"]
    }
    override func viewDidAppear(_ animated: Bool) {
        self.profileImageView.layer.cornerRadius = 50.0
        self.profileImageView.clipsToBounds = true
        self.profileImageView.kf.setImage(with: Auth.auth().currentUser?.photoURL)
        profileNameLabel.text = Auth.auth().currentUser?.displayName
        profileNameLabel.adjustsFontForContentSizeCategory = true
    }

    //MARK:- UITableViewDataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        cell.titleLabel.text = menuList[indexPath.row]
        cell.menuImageView.image = UIImage.init(named: imageList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
        
        let sideMenuController = APPDELEGATE.sideMenuController
        
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            return
        }
        centeralNavController.popToRootViewController(animated: false)
        
        switch indexPath.row {
        case 3:
         
         let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 4:
             
             let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
            
             centeralNavController.setViewControllers([objVC], animated: false)
             sideMenuController.closeSlider(.left, animated: true) { (_) in
                 
             }
             break
//        case 5:
//
//         let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VersionViewController") as! VersionViewController
//
//         centeralNavController.setViewControllers([objVC], animated: false)
//         sideMenuController.closeSlider(.left, animated: true) { (_) in
//
//         }
//         break
        case 0:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
         objVC.currIndex = 0
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 1:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
         
         objVC.currIndex = 1
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
         case 2:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
         objVC.currIndex = 2
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
            
        case 6:
            //Logout
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
                sideMenuController.closeSlider(.left, animated: true) { (_) in
                    
                }
            }
            alert.addAction(okAction)
            alert.addAction(noAction)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            break
            
        default:
            break
        }
        
    }
    
}
