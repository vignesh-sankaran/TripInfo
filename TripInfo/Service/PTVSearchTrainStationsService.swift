
//
//  PTVSearchTrainStationsService
//  TripInfo
//
//  Created by Vignesh Sankaran on 22/12/18.
//  Copyright © 2018 Vignesh Sankaran. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift

class PTVSearchTrainStationsService {
    private let developerID: String
    private let APIKey: String
    
    init () {
        guard let plistPath = Bundle.main.path(forResource: "PTVAPIService", ofType: "plist") else {
            fatalError("Unable to find PTVAPIService.plist!")
        }
        
        guard let params = NSDictionary(contentsOfFile: plistPath) else {
            fatalError("Error converting PTVAPIService.plist into NSDictionary!")
        }
        
        developerID = params["DeveloperID"] as! String
        APIKey = params["SecurityKey"] as! String
    }
    
    func searchStations(stationName: String, callback: @escaping(_ response: String) -> ()) {
        // TODO: Move all URL construction logic to a separate function
        // Set up URL
        var queryURLComponents = URLComponents()
        queryURLComponents.scheme = "http"
        queryURLComponents.host = "timetableapi.ptv.vic.gov.au"
        queryURLComponents.path = "/v3/search/\(stationName)"
        
        let queryItemRouteTypes = URLQueryItem(name: "route_types", value: "[0]")
        let queryItemIncludeOutlets = URLQueryItem(name: "include_outlets", value: "false")
        
        let queryItemDevId = URLQueryItem(name: "devid", value: developerID)
        
        queryURLComponents.queryItems = [queryItemRouteTypes, queryItemIncludeOutlets, queryItemDevId]
        
        let baseURLString = queryURLComponents.string!
        let signature = calculateHMAC(baseURL: baseURLString)
        
        let queryItemSignature = URLQueryItem(name: "signature", value: signature)
        
        // TODO: Figure out another way to append queryItemSignature without having to redeclare the array
        queryURLComponents.queryItems!.append(queryItemSignature)
        
        let URLString = queryURLComponents.string!
        
        callback(URLString)
    }
    
    func calculateHMAC(baseURL: String) -> String {
        // TODO: Switch this out for CommonCrypto.h
        let hmacBytes: [UInt8]
        let keyBytes = APIKey.bytes
        let urlBytes = baseURL.bytes
        
        do {
            hmacBytes = try HMAC(key: keyBytes, variant: .sha1).authenticate(urlBytes)
        } catch {
            fatalError("Failed to generate HMAC signature for url: \(baseURL)")
        }
        
        return hmacBytes.toHexString()
    }
}
