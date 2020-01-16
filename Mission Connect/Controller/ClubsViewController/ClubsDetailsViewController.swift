//
//  ClubsDetailsViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/16/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class ClubsDetailsViewController: UIViewController {

    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topView.setShadow()
        subscribeBtn.layer.cornerRadius = 4.0
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subscribeBtnAction(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Alert", message: "You have subscribed! Please enjoy.", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
