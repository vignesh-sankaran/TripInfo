
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
        let encodedKey = APIKey.cString(using: String.Encoding.utf8)!
        let encodedData = baseURL.cString(using: String.Encoding.utf8)!
        
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
        var rawHash = Array(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
        CCHmac(algorithm, encodedKey, encodedKey.count - 1, encodedData, encodedData.count - 1, &rawHash)
        
        // Convert byte array to hex string
        let hashString = NSMutableString()
        
        for byte in rawHash {
            hashString.appendFormat("%02hhx", byte)
        }
        
        return hashString as String
    }
}
