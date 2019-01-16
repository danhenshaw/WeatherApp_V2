//
//  DarkSkyAPIManager.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 20/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import SafariServices
import Foundation

class DarkSkyAPI {
    
    static let sharedInstance = DarkSkyAPI()
    
    func fetchWeather(latitude: Double, longitude: Double, completionHandler: @escaping (_ forecastArray: ForecastModel?, _ error: Error?) -> Void ) {
        
        let urlString = GlobalVariables.sharedInstance.baseURL + GlobalVariables.sharedInstance.darkSkyAPIKey + "/\(latitude),\(longitude)"
        
        var urlBuilder = URLComponents(string: urlString)!
        var queryItems: [URLQueryItem] = []

        queryItems.append(URLQueryItem(name: "units", value: GlobalVariables.sharedInstance.units))
        queryItems.append(URLQueryItem(name: "lang", value: GlobalVariables.sharedInstance.language))
        
        urlBuilder.queryItems = queryItems
        
        let urlSearcher = urlBuilder.url!
        
        let task = URLSession.shared.dataTask(with: urlSearcher) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ForecastModel.self, from: data)
                
                if (responseData.currently?.temperature) != nil  {
                    completionHandler(responseData, nil)
                } else {
                    completionHandler(nil, error)
                }
                
            } catch {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
}

