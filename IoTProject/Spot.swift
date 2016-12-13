//
//  Spot.swift
//  IoTProject
//
//  Created by Project NMWSU on 12/12/16.
//  Copyright © 2016 Project NMWSU. All rights reserved.
//

import Foundation

struct Spot{
    
    private var _spotName:String = ""
    
    private var _spotStatus:String = ""
    
    var spotName:String{
        set{
            _spotName = newValue
        }
        get{
            return _spotName
        }
    }
    
    var spotStatus:String{
        set{
            _spotStatus = newValue
        }
        get{
            return _spotStatus
        }
    }
    
    
    init(spotNameI: String, spotStatusI: String) {
        _spotName = spotNameI
        _spotStatus = spotStatusI
    }
    
    
}
