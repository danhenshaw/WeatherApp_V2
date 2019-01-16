//
//  SettingsModel.swift
//  WeatherApp_V5
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

class LocationListItem {
    
    var cityName: String?
    var longitude: Double?
    var latitude: Double?
    var temp: String?
    var isBackgroundDark: Bool?
    var summary: String?
    var time: String?
    var isCurrentLocation: Bool?
    
}

class LocationListModel {
    
    var locationListData: [LocationListItem]?
    
    init(withLocations locationListData: [LocationListItem]?) {
        self.locationListData = locationListData
    }

}

