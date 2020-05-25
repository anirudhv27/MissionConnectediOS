//
//  CustomTabBarViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/18/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UIViewController {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var publishLabel: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var clubBtn: UIButton!
    @IBOutlet weak var publishBtn: UIButton!
    
    var homeVC : HomeViewController!
    var clubVC : ClubViewController!
    var publishVC : PublishViewController!
    
    var navHome: UINavigationController!
    var navClub: UINavigationController!
    var navPublish: UINavigationController!
   
    var controller : UINavigationController!
    var controllerArray : Array<UINavigationController>!
    
    var currIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setsNavigationController()
        
        self.resetSelectedBtn(index: currIndex)
        if currIndex == 0{
            homeBtn.isSelected = true
            homeBtn.tintColor = .systemGreen
        } else if currIndex == 1 {
            clubBtn.isSelected = true
            clubBtn.tintColor = .systemGreen
        } else if currIndex == 2 {
            publishBtn.isSelected = true
            publishBtn.tintColor = .systemGreen
        }
        
        self.setInitialController(index: currIndex)
    }
    
    
    @IBAction func commonBtnAction(_ sender: UIButton) {
        self.resetSelectedBtn(index: sender.tag - 100)
        sender.isSelected = true
        sender.tintColor = .systemGreen
        self.setInitialController(index: sender.tag - 100)
    }
    
    func resetSelectedBtn(index: Int){
       
        homeBtn.isSelected = false;
        clubBtn.isSelected = false;
        publishBtn.isSelected = false;

       
        homeLabel.textColor = UIColor.darkGray
        clubLabel.textColor = UIColor.darkGray
        publishLabel.textColor = UIColor.darkGray
       
       
        self.homeBtn.tintColor = UIColor.lightGray
        self.clubBtn.tintColor = UIColor.lightGray
        self.publishBtn.tintColor = UIColor.lightGray
        

        if index == 0 {
            homeLabel.textColor = .black
        }else if index == 1 {
            clubLabel.textColor = .black
        }else if index == 2 {
            publishLabel.textColor = .black
        }

    }
    
    private func setsNavigationController() {
        
        let image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        let image1 = UIImage(named: "clubs")?.withRenderingMode(.alwaysTemplate)
        let image2 = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
        

        self.homeBtn.setImage(image, for: .normal)
        self.clubBtn.setImage(image1, for: .normal)
        self.publishBtn.setImage(image2, for: .normal)
        

        homeVC = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
        clubVC = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClubViewController") as! ClubViewController)
        publishVC = (UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "PublishViewController") as! PublishViewController)
       
        
        self.navHome = UINavigationController(rootViewController: homeVC)
        self.navClub = UINavigationController(rootViewController: clubVC)
        self.navPublish = UINavigationController(rootViewController: publishVC)
       
        
        self.controllerArray = [self.navHome,self.navClub,self.navPublish]
    }
    
    func setInitialController(index : Int){
         self.controllerArray = [self.navHome,self.navClub,self.navPublish]

        for subview in mainContainerView.subviews {
            subview.removeFromSuperview()
        }
        self.controller = self.controllerArray[index]
        controller.view.frame = mainContainerView.bounds
        mainContainerView.addSubview(controller.view)
        self.addChild(controller)
        
        controller.didMove(toParent: self)
        self.controller.isNavigationBarHidden = true
        self.view.endEditing(true)
        if controller.viewControllers.count > 1 {
            controller.popToRootViewController(animated: false)
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
