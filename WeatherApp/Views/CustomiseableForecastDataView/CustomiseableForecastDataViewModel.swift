//
//  CustomiseableForecastDataViewModel.swift
//  WeatherApp
//
//  Created by Daniel Henshaw on 21/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import Foundation

final class CustomiseableForecastDataViewModel {
    
    fileprivate var model: CustomiseableForecastDataModel
    
    fileprivate let constants = GlobalVariables.sharedInstance
    
    init(withModel model: CustomiseableForecastDataModel) {
        self.model = model
    }
    
    func numberOfSections() -> Int {
        return model.forecastDataTypes.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return model.forecastDataTypes[section].isCollapsed ? 0 : model.forecastDataTypes[section].items.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> ForecastDataItem {
        let section = model.forecastDataTypes[indexPath.section]
        return section.items[indexPath.item]
    }
    
    func headerTitle(_ section: Int) -> String {
        let title = model.forecastDataTypes[section].name
        switch title {
        case .daily : return "Daily Data"
        case .currently : return "Current Data"
        case .hourly : return "Hourly Data"
        default : return "--"
        }
    }
    
    func forecastTypeForSection(_ section: Int) -> ForecastSection {
        return model.forecastDataTypes[section].name
    }
    
    func updatedCollapsedFor(section: Int) {
        model.forecastDataTypes[section].isCollapsed = !model.forecastDataTypes[section].isCollapsed
    }
    
    func sectionIsCollapsed(section: Int) -> Bool {
        return model.forecastDataTypes[section].isCollapsed
    }
    
    
}
