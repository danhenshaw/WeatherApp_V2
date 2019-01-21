//
//  SettingsViewModel.swift
//  WeatherApp_V5
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

final class LocationListViewModel {
    
    fileprivate let model: LocationListModel
    
    init(withModel model: LocationListModel) {
        self.model = model
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        let dataCount = model.locationListData?.count ?? 0
        if isUsingCurrentLocation() {
            return dataCount - 1
        } else {
            return dataCount
        }
    }
    
    func locationItemForIndexPath(_ indexPath: Int) -> LocationListItem? {
        let index = model.locationListData?[indexPath]
        return index
    }
    
    func removeItem(_ forIndexPath: Int) {
        model.locationListData?.remove(at: forIndexPath)
    }
    
    func addItem(_ newCity: LocationListItem) {
        model.locationListData?.append(newCity)
    }
    
    func isUsingCurrentLocation() -> Bool {
        return model.locationListData?[0].isCurrentLocation ?? false
    }


}
