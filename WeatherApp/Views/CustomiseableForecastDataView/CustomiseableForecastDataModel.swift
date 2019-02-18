//
//  CustomiseableForecastDataModel.swift
//  WeatherApp
//
//  Created by Daniel Henshaw on 21/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import Foundation
import UIKit

struct ForecastDataGroup {
    let name: ForecastSection
    let items: [ForecastDataItem]
    var isCollapsed: Bool
}

struct ForecastDataItem {
    let title: String
    let value: String
}

struct CustomiseableForecastDataModel {
    
    var forecastDataTypes = [
        
        ForecastDataGroup(
            name: .currently,
            items: [
                ForecastDataItem(title: "Temperature", value: GlobalVariables.sharedInstance.currentlyData[0]),
                ForecastDataItem(title: "Slot 0", value: GlobalVariables.sharedInstance.currentlyData[1]),
                ForecastDataItem(title: "Slot 1", value: GlobalVariables.sharedInstance.currentlyData[2]),
                ForecastDataItem(title: "Slot 2", value: GlobalVariables.sharedInstance.currentlyData[3]),
                ForecastDataItem(title: "Slot 3", value: GlobalVariables.sharedInstance.currentlyData[4])
                ],
            isCollapsed: true
        ),
        
        
        
        ForecastDataGroup(
            name: .hourly,
            items: [
                ForecastDataItem(title: "Slot 0", value: GlobalVariables.sharedInstance.hourlyData[0]),
                ForecastDataItem(title: "Slot 1", value: GlobalVariables.sharedInstance.hourlyData[1]),
                ForecastDataItem(title: "Slot 2", value: GlobalVariables.sharedInstance.hourlyData[2]),
                ForecastDataItem(title: "Slot 3", value: GlobalVariables.sharedInstance.hourlyData[3]),
                ForecastDataItem(title: "Slot 4", value: GlobalVariables.sharedInstance.hourlyData[4]),
                ForecastDataItem(title: "Slot 5", value: GlobalVariables.sharedInstance.hourlyData[5]),
                ForecastDataItem(title: "Slot 6", value: GlobalVariables.sharedInstance.hourlyData[6]),
                ForecastDataItem(title: "Slot 7", value: GlobalVariables.sharedInstance.hourlyData[7]),
            ],
            isCollapsed: true
        ),
        
        
        
        ForecastDataGroup(
            name: .daily,
            items: [
                ForecastDataItem(title: "Slot 0", value: GlobalVariables.sharedInstance.dailyData[0]),
                ForecastDataItem(title: "Slot 1", value: GlobalVariables.sharedInstance.dailyData[1]),
                ForecastDataItem(title: "Slot 2", value: GlobalVariables.sharedInstance.dailyData[2]),
                ForecastDataItem(title: "Slot 3", value: GlobalVariables.sharedInstance.dailyData[3]),
                ForecastDataItem(title: "Slot 4", value: GlobalVariables.sharedInstance.dailyData[4]),
                ForecastDataItem(title: "Slot 5", value: GlobalVariables.sharedInstance.dailyData[5]),
                ForecastDataItem(title: "Slot 6", value: GlobalVariables.sharedInstance.dailyData[6]),
                ForecastDataItem(title: "Slot 7", value: GlobalVariables.sharedInstance.dailyData[7]),
            ],
            isCollapsed: true
        )
    ]
}
