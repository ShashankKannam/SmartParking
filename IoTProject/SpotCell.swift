//
//  SpotCell.swift
//  IoTProject
//
//  Created by Project NMWSU on 12/12/16.
//  Copyright © 2016 Project NMWSU. All rights reserved.
//

import UIKit

class SpotCell: UITableViewCell {

    @IBOutlet weak var spotName: UILabel!

    @IBOutlet weak var spotStatus: UILabel!
    
    @IBOutlet weak var availabilityView: UIView!
    
    func updateUI(spot: Spot){
        spotName.text = spot.spotName
        spotStatus.text = spot.spotStatus
        
        self.availabilityView.layer.cornerRadius = self.availabilityView.layer.frame.size.height
        
        if spot.spotStatus == "Available"{
            availabilityView.backgroundColor = UIColor.green
        }
        else{
            availabilityView.backgroundColor = UIColor.red
        }
    }
}
