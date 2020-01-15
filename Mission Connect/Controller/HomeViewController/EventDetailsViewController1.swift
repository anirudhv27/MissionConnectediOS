//
//  EventDetailsViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/15/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class EventDetailsViewController1: UIViewController {

    @IBOutlet weak var letBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.setShadow()
        self.letBtn.layer.cornerRadius = 4.0
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
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
