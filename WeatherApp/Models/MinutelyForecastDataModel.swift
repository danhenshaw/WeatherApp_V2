//
//  MinutelyForecastDataModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 29/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

struct MinutelyData: Codable {
    var time: Int?
    var precipProbability: Double?
    var precipIntensity: Double?
    var precipIntensityError: Double?
    var precipType: String?
}

struct Minutely: Codable {
    var summary: String?
    var icon: String?
    var data: [MinutelyData]
}
