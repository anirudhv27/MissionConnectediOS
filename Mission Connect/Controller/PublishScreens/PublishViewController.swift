//
//  PublishViewController.swift
//  Mission Connect
//
//  Created by Venkata Valiveru on 1/16/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clubNametextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var allEventBtn: UIButton!
    @IBOutlet weak var addEventBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var enddateBtn: UIButton!
    var isFromStartDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateBtn.layer.cornerRadius = 4.0
        self.dateBtn.layer.borderWidth = 1
        self.dateBtn.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        self.descriptionTextView.layer.cornerRadius = 4.0
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        self.enddateBtn.layer.cornerRadius = 4.0
        self.enddateBtn.layer.borderWidth = 1
        self.enddateBtn.layer.borderColor = UIColor.init(red: (229/255.0), green: (229/255.0), blue: (229/255.0), alpha: (229/255.0)).cgColor
        datePickerView.isHidden = true
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
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
    }
    @IBAction func addEventBtnAction(_ sender: Any) {
        addEventBtn.setTitleColor(.black, for: .normal)
        allEventBtn.setTitleColor(.darkGray, for: .normal)
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

}
