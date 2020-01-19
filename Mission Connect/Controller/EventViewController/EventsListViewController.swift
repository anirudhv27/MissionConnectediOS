//
//  EventsListViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/19/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var pastLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var goingLabel: UILabel!
    @IBOutlet weak var pastBtn: UIButton!
    @IBOutlet weak var goingBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    var selectedTab = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resetButtonAtIndex(index: 0)
    }
    
    func resetButtonAtIndex(index:Int) {
        self.pastBtn.setTitleColor(.lightGray, for: .normal)
        self.allBtn.setTitleColor(.lightGray, for: .normal)
        self.goingBtn.setTitleColor(.lightGray, for: .normal)
        self.pastLabel.isHidden = true
        self.allLabel.isHidden = true
        self.goingLabel.isHidden = true
        if index == 0 {
             self.allBtn.setTitleColor(.black, for: .normal)
            self.allLabel.isHidden = false
        }else if index == 1 {
            self.goingBtn.setTitleColor(.black, for: .normal)
            self.goingLabel.isHidden = false
        }else {
            self.pastBtn.setTitleColor(.black, for: .normal)
            self.pastLabel.isHidden = false
        }
        selectedTab = index
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pastBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 2)
    }
    
    @IBAction func goingBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 1)
    }
    
    @IBAction func allBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 0)
    }
    
    //MARK: - UItableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        
        cell.menuImageView.image = UIImage.init(named: "event")
        cell.titleLabel.text = "14 January 2020 14:00"
        cell.subTitleLabel.text = "Event Title"
        cell.memberLabel.text = "Club name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailsViewController1") as! EventDetailsViewController1
        self.navigationController?.pushViewController(objVC, animated: true)
    }
}
