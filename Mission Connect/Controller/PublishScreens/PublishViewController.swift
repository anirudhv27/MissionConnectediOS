//
//  PublishViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/16/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var clubNametextField: UITextField!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var allEventBtn: UIButton!
    @IBOutlet weak var addEventBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var enddateBtn: UIButton!
    
    //event outlet
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventTableView: UITableView!
    
    var isFromStartDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateBtn.layer.cornerRadius = 4.0
        self.dateBtn.layer.borderWidth = 1
        self.dateBtn.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        self.descriptionTextView.layer.cornerRadius = 4.0
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        
        self.eventImageView.layer.cornerRadius = 4.0
        self.eventImageView.layer.borderWidth = 1
        self.eventImageView.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        
        self.enddateBtn.layer.cornerRadius = 4.0
        self.enddateBtn.layer.borderWidth = 1
        self.enddateBtn.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        datePickerView.isHidden = true
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        dateBtn.setTitle("", for: .normal)
        enddateBtn.setTitle("", for: .normal)
        eventView.isHidden = true
    }
    
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute {
            if isFromStartDate {
                dateBtn.setTitle("\(day)/\(month)/\(year) : \(hour):\(minute)", for: .normal)
            }else {
                enddateBtn.setTitle("\(day)/\(month)/\(year) : \(hour):\(minute)", for: .normal)
            }
            
        }
       
    }
    
    //MARK:- ImagePickerMethods
    func openImagePickerOption(){
        
        self.view.endEditing(true)
        
        let myActionSheet = UIAlertController()
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cmaeraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cmaeraAction)
        myActionSheet.addAction(cancelAction)
       
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func openCamera(){
        
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))  {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                self .present(imagePicker, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Camera is not supported", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func openGallary() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true //2
        imagePicker.sourceType = .photoLibrary //3
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if  let pickedImage: UIImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) {
            self.eventImageView.contentMode = .scaleAspectFill
            self.eventImageView.image = pickedImage
        }
    }
    
    @IBAction func imageBtnAction(_ sender: Any) {
        self.openImagePickerOption()
    }
    
    @IBAction func enddateBtnAction(_ sender: Any) {
        self.isFromStartDate = false
        self.datePickerView.isHidden = false
    }
    @IBAction func dateBtn(_ sender: Any) {
        self.isFromStartDate = true
        self.datePickerView.isHidden = false
    }
    @IBAction func allEventBtnAction(_ sender: Any) {
        allEventBtn.setTitleColor(.black, for: .normal)
         addEventBtn.setTitleColor(.darkGray, for: .normal)
        self.eventView.isHidden = false
    }
    @IBAction func addEventBtnAction(_ sender: Any) {
        addEventBtn.setTitleColor(.black, for: .normal)
        allEventBtn.setTitleColor(.darkGray, for: .normal)
        self.eventView.isHidden = true
    }
    
    @IBAction func publishBtnAction(_ sender: Any) {
        
        var message = ""
        if clubNametextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            message = "Please select Club"
        }else if eventNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            message = "Please enter Event title"
        }else if dateBtn.titleLabel?.text?.count == 0 {
            message = "Please select Event Start Date"
        }else if enddateBtn.titleLabel?.text?.count == 0{
            message = "Please select Event End Date"
        }else if descriptionTextView.text.trimmingCharacters(in: .whitespaces).count  == 0{
            message = "Please enter Event description"
        }else if eventImageView.image == UIImage.init(named: "add") {
            message = "Please select Event Image"
        }else {
            message = "Event publish successfully."
            clubNametextField.text = ""
            eventNameTextField.text = ""
            dateBtn.setTitle("", for: .normal)
            enddateBtn.setTitle("", for: .normal)
            descriptionTextView.text = ""
            eventImageView.contentMode = .center
            eventImageView.image = UIImage.init(named: "add")
            allEventBtn.setTitleColor(.black, for: .normal)
             addEventBtn.setTitleColor(.darkGray, for: .normal)
            self.eventView.isHidden = false
            
        }
        
        let alertController = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func dateBtnAction(_ sender: Any) {
        self.datePickerView.isHidden = true
    }
    //MARK: - UICollectionViewDelegate and dataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelCollectionViewCell", for: indexPath) as! ImageLabelCollectionViewCell
        cell.imageview.layer.cornerRadius = 10.0
        cell.imageview.clipsToBounds = true
        cell.titleLabel.text = "Club title"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 120.0, height: 138)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clubNametextField.text = "Club Dummy Title"
    }
    
    //MARK: - UItableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableViewCell") as! SideTableViewCell
        
        cell.menuImageView.image = UIImage.init(named: "event")
        cell.titleLabel.text = "14 January 2020 14:00"
       // cell.endDateLabel.text = "16 January 2020 14:00"
        cell.subTitleLabel.text = "Event Title"
        cell.memberLabel.text = "Club name"
        
        cell.editBtn.layer.cornerRadius = 4.0
        cell.deleteBtn.layer.cornerRadius = 4.0
        cell.editBtn.addTarget(self, action: #selector(self.editEventBtnAction(sender:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteEventBtnAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func editEventBtnAction(sender: UIButton) {
        self.eventView.isHidden = true
        clubNametextField.text = "Club dummy title"
        eventNameTextField.text = "Event dummy name"
        dateBtn.setTitle("", for: .normal)
        enddateBtn.setTitle("", for: .normal)
        descriptionTextView.text = ""
        eventImageView.contentMode = .center
        eventImageView.image = UIImage.init(named: "add")
        allEventBtn.setTitleColor(.darkGray, for: .normal)
         addEventBtn.setTitleColor(.black, for: .normal)
        
    }
    
    @objc func deleteEventBtnAction(sender: UIButton) {
           let alertController = UIAlertController.init(title: "Delete!", message: "Event deleted successfully.", preferredStyle: .alert)
           let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
               
           }
           alertController.addAction(okAction)
           self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailsViewController1") as! EventDetailsViewController1
        objVC.isOfficer = true
        self.navigationController?.pushViewController(objVC, animated: true)
    }

}
