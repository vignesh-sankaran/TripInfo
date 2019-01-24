//
//  SelectStationViewModel.swift
//  TripInfo
//
//  Created by Vignesh Sankaran on 23/12/18.
//  Copyright © 2018 Vignesh Sankaran. All rights reserved.
//

import Foundation
import Alamofire

extension Notification.Name {
    static let stationListPopulated = Notification.Name("stationListPopulated")
}

class SelectStationViewModel {
    private var stations: [SelectStationCellViewModel]
    
    var count: Int {
        return stations.count
    }
    
    var stationList: [SelectStationCellViewModel] {
        return stations
    }
    
    init() {
        stations = []
    }
    
    public func populate(stationName: String) {
        // TODO: Handle edge cases with the API call
        
        // Start service, handle population in callback
        PTVSearchTrainStationsService().searchStations(stationName: stationName, callback: completePopulate)
    }
    
    private func completePopulate(response: DataResponse<Any>) {
        // Parse JSON, put into structs
        // TODO: Remove force unwraps
        let response = response.result.value!
        let responseDict = response as! NSDictionary
        
        let stops = responseDict.object(forKey: "stops") as! NSArray
        
        for stop in stops {
            let stopDict = stop as! NSDictionary
            let stopIdInt = stopDict.object(forKey: "stop_id") as! Int
            let stopName = stopDict.object(forKey: "stop_name") as! String
            
            let stopId = String(stopIdInt)
            
            let stationViewModel = SelectStationCellViewModel(stationName: stopName, stopId: stopId)
            stations.append(stationViewModel)
        }
        
        NotificationCenter.default.post(name: .stationListPopulated, object: nil)
    }
}
