//
//  ClubsDetailsViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/16/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class ClubsDetailsViewController: UIViewController {

    @IBOutlet weak var allEventBtn: UIButton!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    var isFromMyClub = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topView.setShadow()
        subscribeBtn.layer.cornerRadius = 4.0
        
        if isFromMyClub {
            self.subscribeBtn.backgroundColor = .systemRed
            self.subscribeBtn.setTitle("UnSubscribe", for: .normal)
        }
        
    }
    
    @IBAction func allEventBtnAction(_ sender: Any) {
        let objVC = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "EventsListViewController") as! EventsListViewController
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subscribeBtnAction(_ sender: Any) {
        if isFromMyClub {
            let alertController = UIAlertController.init(title: "Alert", message: "You have unsubscribed!", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else {
            let alertController = UIAlertController.init(title: "Alert", message: "You have subscribed! Please enjoy.", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
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
