//
//  ForecastModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 20/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

enum ForecastSection {
    case currently, minutely, hourly, daily, sunrise, sunset
}

enum MinutelyForecastDataType {
    case time
}

struct ForecastModel: Codable {

    let currently : Currently?
    let minutely : Minutely?
    let hourly : Hourly?
    let daily : Daily?
    
    var cityName: String?
    var latitude: Double?
    var longitude: Double?
    var timezone: String?
}
