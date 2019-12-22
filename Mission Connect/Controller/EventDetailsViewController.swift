//
//  EventDetailsViewController.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 12/1/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    var event: Event!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameLabel.text = event.eventTitle
        clubNameLabel.text = event.clubName
        eventDescriptionLabel.text = event.eventDescription
        
        // Do any additional setup after loading the view.
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
