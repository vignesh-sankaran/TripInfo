
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
        let URLString = constructURL(stationName: stationName)
        
        callback(URLString)
    }
    
    func constructURL(stationName: String) -> String {
        var queryURLComponents = URLComponents()
        queryURLComponents.scheme = "http"
        queryURLComponents.host = "timetableapi.ptv.vic.gov.au"
        queryURLComponents.path = "/v3/search/\(stationName)"
        
        let queryItemRouteTypes = URLQueryItem(name: "route_types", value: "[0]")
        let queryItemIncludeOutlets = URLQueryItem(name: "include_outlets", value: "false")
        
        let queryItemDevId = URLQueryItem(name: "devid", value: developerID)
        
        queryURLComponents.queryItems = [queryItemRouteTypes, queryItemIncludeOutlets, queryItemDevId]
        
        // There is an unusual quirk in that a URLComponent query string does not return a
        // string that is properly percent encoded as per RFC 3986
        let queryString = queryURLComponents.query!
        let encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let endpoint = queryURLComponents.path + "?" + encodedQueryString
        
        let signature = calculateHMAC(URLSegment: endpoint)
        
        let queryItemSignature = URLQueryItem(name: "signature", value: signature)
        
        // TODO: Figure out another way to append queryItemSignature without having to redeclare the array
        queryURLComponents.queryItems!.append(queryItemSignature)
        
        return queryURLComponents.string!
    }
    
    func calculateHMAC(URLSegment: String) -> String {
        let hmacBytes: [UInt8]
        let segmentBytes = URLSegment.bytes
        let APIKeyBytes = APIKey.bytes
        
        do {
            hmacBytes = try HMAC(key: APIKeyBytes, variant: .sha1).authenticate(segmentBytes)
        } catch {
            fatalError("Failed to generate HMAC signature for url: \(URLSegment)")
        }
        
        return hmacBytes.toHexString()
    }
}
