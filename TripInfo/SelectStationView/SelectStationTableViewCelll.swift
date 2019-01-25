//
//  StationTableViewCell.swift
//  TripInfo
//
//  Created by Vignesh Sankaran on 14/12/18.
//  Copyright © 2018 Vignesh Sankaran. All rights reserved.
//

import Foundation
import UIKit

class SelectStationTableViewCell: UITableViewCell {
    var stopId: String? = nil
    @IBOutlet weak var stationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
