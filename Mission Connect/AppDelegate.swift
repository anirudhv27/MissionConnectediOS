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
import FirebaseAuth

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
        self.gotoRouteScreen()
        
        return true
    }
    
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
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        let email: String = user.profile.email;
        let domain: String = email.components(separatedBy: "@")[1]
        
        if (true){ //domain == "fusdk12.net"
            Auth.auth().signIn(with: credential, completion: { (u, error) in
                if let error = error {
                    print("Failed to create a Firebase User with google Account", error)
                }
                
                print("Success for Firebase User!", user.userID as Any)
                
                if Auth.auth().currentUser != nil {
                    self.window?.rootViewController!.performSegue(withIdentifier: "officerLoginSegue", sender: LoginViewController.self)
                }
                
            })
        } else {
            
            let alert: UIAlertController = UIAlertController(title: "Invalid Sign In", message: "Please try again with your FUSD GAFE account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.window?.rootViewController!.present(alert, animated: true)
        }
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
        GIDSignIn.sharedInstance()?.signIn()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - Helper methods for SideMenu
    func gotoRouteScreen() {
        
       
        navigationController = UINavigationController.init(rootViewController: sideMenuController)
        navigationController.navigationBar.isHidden = true
        window = UIWindow.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window!.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
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
        
        let mainViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
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

