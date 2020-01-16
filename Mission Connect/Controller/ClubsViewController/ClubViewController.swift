//
//  ClubViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 12/22/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit

class ClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var startClubLabel: UILabel!
    @IBOutlet weak var myClubLabel: UILabel!
    @IBOutlet weak var allClubLabel: UILabel!
    @IBOutlet weak var startClubBtn: UIButton!
    @IBOutlet weak var myClubBtn: UIButton!
    @IBOutlet weak var allClubBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.topView.setShadow()
        self.resetButtonAtIndex(index: 0)
    }
    
    func resetButtonAtIndex(index: Int) {
        self.allClubBtn.setTitleColor(.lightGray, for: .normal)
        self.myClubBtn.setTitleColor(.lightGray, for: .normal)
        self.startClubBtn.setTitleColor(.lightGray, for: .normal)
        self.allClubLabel.isHidden = true
        self.myClubLabel.isHidden = true
        self.startClubLabel.isHidden = true
        
        if index == 0{
            self.allClubBtn.setTitleColor(.black, for: .normal)
            self.allClubLabel.isHidden = false
        }else if index == 1 {
            self.myClubBtn.setTitleColor(.black, for: .normal)
            self.myClubLabel.isHidden = false
        }else {
            self.startClubBtn.setTitleColor(.black, for: .normal)
            self.startClubLabel.isHidden = false
        }
    }
    
    @IBAction func startClubBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 2)
    }
    @IBAction func myClubBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 1)
    }
    @IBAction func allClubBtnAction(_ sender: Any) {
        self.resetButtonAtIndex(index: 0)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - UItableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        
        cell.menuImageView.image = UIImage.init(named: "event")
        cell.titleLabel.text = "Club Title"
        cell.subTitleLabel.text = "Club SubTitle"
        cell.memberLabel.text = "Member Status"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objvc = UIStoryboard.init(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "ClubsDetailsViewController") as! ClubsDetailsViewController
               self.navigationController?.pushViewController(objvc, animated: true)
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
