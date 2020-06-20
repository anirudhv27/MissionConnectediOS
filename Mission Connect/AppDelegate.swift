//
//  AppDelegate.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/28/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    var privateSideMenuController: MASliderViewController?
    var navigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        gotoDummyScreen() // shows sign-in screen
//        if UserDefaults.standard.bool(forKey: "isUserSignedIn") {
//            self.gotoRouteScreen()
//        } else {
//            self.gotoDummyScreen()
//        }
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //TODO - Implement SignInFor
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("Failed to log in to Google", error)
            return
        }
        
        print("Success!", user.userID as Any)
        
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        let email: String = user.profile.email;
        let domain: String = email.components(separatedBy: "@")[1]
        
        if (domain == "fusdk12.net" || email == "avaliveru@gmail.com" || email == "missionconnected2020@gmail.com"){
            Auth.auth().signIn(with: credential, completion: { (u, error) in
                if let error = error {
                    print("Failed to create a Firebase User with google Account", error)
                }
                
                print("Success for Firebase User!", user.userID as Any)
                
                FIRHelperClass.sharedInstance.isExistUser(email: (Auth.auth().currentUser?.email)!) { (exist) in
                    if exist {
                        self.gotoRouteScreen()
                    } else {
//                        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("fullname").setValue(user.profile.name)
//                        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("imgurl").setValue(user.profile.imageURL(withDimension: 200)?.absoluteString)
//                        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("email").setValue(user.profile.email)
//                        
                        self.gotoRegisterScreen(fullName: user.profile.name, imgUrl: user.profile.imageURL(withDimension: 200)!.absoluteString, email: user.profile.email, id: Auth.auth().currentUser!.uid)
                    }
                }
//
//                if Auth.auth().currentUser != nil // user is successfully authenticated
//                {
//                    self.gotoRouteScreen()
//
//                } else {
//
//                }
                
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "isUserSignedIn")
            })
        } else {
            
            let alert: UIAlertController = UIAlertController(title: "Invalid Sign In", message: "Please try again with your FUSD GAFE account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.window?.rootViewController!.present(alert, animated: true)
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.gotoDummyScreen()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isUserSignedIn")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }

    //MARK: - Helper methods for SideMenu
    func gotoDummyScreen() { // go to sign in screen
        let objvc = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "RouteViewController") as! RouteViewController
       
        navigationController =  UINavigationController.init(rootViewController: objvc)
        navigationController.navigationBar.isHidden = true
        
        window = UIWindow.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window!.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func gotoRouteScreen() { // go to main app area
        sideMenuController.centerViewController?.closeSlider()
        let menu = sideMenuController.centerViewController as! UINavigationController
        let tab = menu.viewControllers.first as! CustomTabBarViewController
        tab.currIndex = 0
        navigationController = UINavigationController.init(rootViewController: sideMenuController)
        navigationController.navigationBar.isHidden = true
        window = UIWindow.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window!.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func gotoRegisterScreen(fullName: String, imgUrl: String, email: String, id: String) {
        let objvc = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        objvc.id = id
        objvc.email = email
        objvc.fullname = fullName
        objvc.imgurl = imgUrl
        
        navigationController =  UINavigationController.init(rootViewController: objvc)
        navigationController.navigationBar.isHidden = true
        
        window = UIWindow.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window!.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    //MARK: - Tab Bar setup:  DO NOT TOUCH
    func setNavigationController(navigation:UINavigationController) {
        navigation.navigationBar.isTranslucent = false
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        navigation.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.isHidden = true
    }
    
    var sideMenuController: MASliderViewController {
        
        if let privateSideMenuController = privateSideMenuController {
            return privateSideMenuController
        }
        
        let mainViewController = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        
        let drawerViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        
        let centerNavController = UINavigationController.init(rootViewController: mainViewController)
        privateSideMenuController?.navigationController?.navigationBar.isHidden = true;
        let sliderViewController = MASliderViewController()
        self.setNavigationController(navigation: centerNavController)
        sliderViewController.leftViewController = drawerViewController
        sliderViewController.centerViewController = centerNavController
        sliderViewController.leftDrawerWidth = 300
        privateSideMenuController = sliderViewController
        return privateSideMenuController!
    }
}

