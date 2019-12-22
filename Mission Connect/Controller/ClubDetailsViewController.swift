//
//  ClubDetailsViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 11/30/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit

class ClubDetailsViewController: UIViewController {
    
    var club: Club!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var clubDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubNameLabel.text = club.clubName
        clubDescriptionLabel.text = club.clubDescription
    }

    @IBAction func subscribeButtonPressed(_ sender: Any) {
        let okActionBtn = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
              self.navigationController?.popToRootViewController(animated: true)
        })
        let alert: UIAlertController = UIAlertController(title: "Sorry!", message: "Subscribe Functionality is still in development!", preferredStyle: .alert)
        alert.addAction(okActionBtn)
        self.present(alert, animated: true)
    }
}
