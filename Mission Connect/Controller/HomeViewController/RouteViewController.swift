//
//  RouteViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/18/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        centerView.setShadowWithZeroSize()
        signInBtn.layer.cornerRadius = 4.0
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
        APPDELEGATE.gotoRouteScreen()
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
