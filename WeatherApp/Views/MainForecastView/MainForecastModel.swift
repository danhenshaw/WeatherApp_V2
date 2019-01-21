//
//  MainForecastModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

class MainForecastModel {
    
    var cityData: [CityDataModel]
    
    init(withCities cityData: [CityDataModel]) {
        self.cityData = cityData
    }
    
}
