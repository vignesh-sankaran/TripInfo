
//
//  PTVSearchTrainStationsService
//  TripInfo
//
//  Created by Vignesh Sankaran on 22/12/18.
//  Copyright © 2018 Vignesh Sankaran. All rights reserved.
//

import Foundation
import Alamofire

class PTVSearchTrainStationsService {
    init () {}
    
    class func searchStations(stationName: String, callback: @escaping(_ response: Any?) -> ()) {
        // Set up URL
        var queryURLComponents = URLComponents()
        queryURLComponents.scheme = "http"
        queryURLComponents.host = "timetableapi.ptv.vic.gov.au"
        queryURLComponents.path = "/v3/search/\(stationName)"
        
        let queryItemRouteTypes = URLQueryItem(name: "route_types", value: "[0]")
        let queryItemIncludeOutlets = URLQueryItem(name: "include_outlets", value: "false")
        
        // Get DevId from PTVAPIService plist
        guard let plistPath = Bundle.main.path(forResource: "PTVAPIService", ofType: "plist") else {
            fatalError("Unable to find PTVAPIService.plist!")
        }
        
        guard let params = NSDictionary(contentsOfFile: plistPath) else {
            fatalError("Error converting PTVAPIService.plist into NSDictionary!")
        }
        
        let devId = params["DevId"] as! String
        let queryItemDevId = URLQueryItem(name: "devid", value: devId)
        
        // Calculate HMAC signature
    }
    
    
}
