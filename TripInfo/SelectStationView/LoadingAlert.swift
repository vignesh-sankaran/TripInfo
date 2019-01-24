//
//  LoadingAlert.swift
//  TripInfo
//
//  Created by Vignesh Sankaran on 24/1/19.
//  Copyright © 2019 Vignesh Sankaran. All rights reserved.
//

import UIKit

class LoadingAlert {
    // Credit to ylin0x81 and petesalt. Retrieved 11 Jan 2019 from https://stackoverflow.com/a/27034447/5891072
    class func create() -> UIAlertController {
        let pending = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        return pending
    }
}
