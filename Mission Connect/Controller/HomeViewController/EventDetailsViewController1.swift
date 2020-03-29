//
//  EventDetailsViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/15/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class EventDetailsViewController1: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var commenttextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var letBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event?
    
    var isOfficer = false
    
    var commentList = ["Good one", "Nice", "Beautiful"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.setShadow()
        self.letBtn.layer.cornerRadius = 4.0
        
        if isOfficer {
            letBtn.isHidden = true
        }
        titleLabel.text = event?.event_name
        eventImageView.imageFromURL(urlString: event?.eventImageURL ?? "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y = -265
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if commenttextField.text!.trimmingCharacters(in: .whitespaces).count > 0 {
            commentList.append(commenttextField.text!)
            self.myTableView.reloadData()
            commenttextField.text  = ""
        }
        return true
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        if commenttextField.text!.trimmingCharacters(in: .whitespaces).count > 0 {
            commentList.append(commenttextField.text!)
            self.myTableView.reloadData()
            commenttextField.text  = ""
        }
        
    }
    @IBAction func backBtnAction(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
    
    //MARK: - UITableViewDelegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell") as! CommonTableViewCell
            cell.descriptionLabel.text = event?.event_description
            cell.likeBtn.addTarget(self, action: #selector(likeBtnAction(sender:)), for: .touchUpInside)
            return  cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell1") as! CommonTableViewCell
            cell.profileImageView.image = UIImage.init(named: "user")
            cell.nameLabel.text = "Anirudh"
            cell.commentStrlabel.text = commentList[indexPath.row - 1]
            return  cell
        }
        
    }
    
    @objc func likeBtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
