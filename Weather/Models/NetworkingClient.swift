//
//  NetworkingClient.swift
//  Weather
//
//  Created by Winnie Zhu on 11/24/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingClient {
    typealias webServiceResponse = ([[String: Any]]?, Error?) -> Void
    func getLocWea(lat: String, lng: String, completion: @escaping webServiceResponse) {
        let url = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/getForecast?lat=" + lat + "&lng=" + lng + "&city=&state=";
        print(url);
        Alamofire.request(url).validate().responseJSON { response in
            if let error = response.error {
                completion(nil, error);
            } else if let jsonArray = response.result.value as? [[String: Any]] {
                completion(jsonArray, nil);
            } else if let jsonDic = response.result.value as? [String: Any] {
                completion([jsonDic], nil);
            }
        }
        
    }
    
    
}
