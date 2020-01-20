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
    var isOfficer = false
    
    var commentList = ["Good one", "Nice", "Beautifull"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.setShadow()
        self.letBtn.layer.cornerRadius = 4.0
        
        if isOfficer {
            letBtn.isHidden = true
        }
        
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
            cell.descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
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
