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
    let name: String
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
            name: "Current Data",
            items: [
                ForecastDataItem(title: "Temperature", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .currently, index: 0) ?? "--"),
                ForecastDataItem(title: "Slot 0", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .currently, index: 1) ?? "--"),
                ForecastDataItem(title: "Slot 1", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .currently, index: 2) ?? "--"),
                ForecastDataItem(title: "Slot 2", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .currently, index: 3) ?? "--"),
                ForecastDataItem(title: "Slot 3", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .currently, index: 4) ?? "--")
                ],
            isCollapsed: true
        ),
        
        
        
        ForecastDataGroup(
            name: "Hourly Data",
            items: [
                ForecastDataItem(title: "Slot 0", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 0) ?? "--"),
                ForecastDataItem(title: "Slot 1", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 1) ?? "--"),
                ForecastDataItem(title: "Slot 2", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 2) ?? "--"),
                ForecastDataItem(title: "Slot 3", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 3) ?? "--"),
                ForecastDataItem(title: "Slot 4", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 4) ?? "--"),
                ForecastDataItem(title: "Slot 5", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 5) ?? "--"),
                ForecastDataItem(title: "Slot 6", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 6) ?? "--"),
                ForecastDataItem(title: "Slot 7", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .hourly, index: 7) ?? "--")
            ],
            isCollapsed: true
        ),
        
        
        
        ForecastDataGroup(
            name: "Daily Data",
            items: [
                ForecastDataItem(title: "Slot 0", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 0) ?? "--"),
                ForecastDataItem(title: "Slot 1", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 1) ?? "--"),
                ForecastDataItem(title: "Slot 2", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 2) ?? "--"),
                ForecastDataItem(title: "Slot 3", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 3) ?? "--"),
                ForecastDataItem(title: "Slot 4", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 4) ?? "--"),
                ForecastDataItem(title: "Slot 5", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 5) ?? "--"),
                ForecastDataItem(title: "Slot 6", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 6) ?? "--"),
                ForecastDataItem(title: "Slot 7", value: ForecastDataTypeModel().getForecastDataTypeString(forecastSection: .daily, index: 7) ?? "--")
            ],
            isCollapsed: true
        )
    ]
}
