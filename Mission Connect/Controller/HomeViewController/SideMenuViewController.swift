//
//  SideMenuViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/14/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit
import GoogleSignIn

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    
    var menuList = [String]()
    var imageList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuList = ["Support","User Aggreement","Privacy Policy","Security","Version","Settings","Dashboard","Clubs","Events","LogOut"]
        imageList = ["support","document","privacypolicy","security","version","settings","home","clubs","events","logout"]
        self.profileImageView.layer.cornerRadius = 50.0
        self.profileImageView.clipsToBounds = true
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
        case 0:
         
         let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 1:
            
            let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserAggrementViewController") as! UserAggrementViewController
           
            centeralNavController.setViewControllers([objVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                
            }
            break
        case 2:
             
             let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
            
             centeralNavController.setViewControllers([objVC], animated: false)
             sideMenuController.closeSlider(.left, animated: true) { (_) in
                 
             }
             break
        case 3:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 4:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "SecurityViewController") as! CustomTabBarViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 5:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 6:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 7:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
        case 8:
         
         let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        
         centeralNavController.setViewControllers([objVC], animated: false)
         sideMenuController.closeSlider(.left, animated: true) { (_) in
             
         }
         break
            
        case 9:
            //Logout
            let alert = UIAlertController.init(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Yes", style: .default) { (action) in
                GIDSignIn.sharedInstance()?.signOut()
                
                let storyboard = UIStoryboard(name: "Other", bundle: nil)
                let initial = storyboard.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = initial
            }
            
            let noAction = UIAlertAction.init(title: "No", style: .cancel) { (action) in
                
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
