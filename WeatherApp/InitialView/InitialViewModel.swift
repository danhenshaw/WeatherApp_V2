//
//  ViewModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation
import CoreLocation

protocol InitialViewModelDelegate: class {
    func viewModel(_ viewModel: InitialViewModel, didEnableLocationServices currentLocation: CLLocation)
    func viewModel(_ viewModel: InitialViewModel, didSetDefaultLocation defaultLocation: CLLocation)
}


class InitialViewModel {
    
    weak var delegate: InitialViewModelDelegate?
    fileprivate var coreDataManager: CoreDataManager
    var cityData = [CityDataModel]()
    
    struct DefaultSettings {
        static let language = "en"
        static let units = "us"
    }

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        restoreUserSettingsFromStorage()
        getLocationsFromCoreData()
    }
    
    
    func restoreUserSettingsFromStorage() {
        let language = UserDefaults.standard.string(forKey: "LanguageKey") ?? DefaultSettings.language
        let units = UserDefaults.standard.string(forKey: "UnitsKey") ?? DefaultSettings.units
        GlobalVariables.sharedInstance.update(value: .language, toNewValue: language)
        GlobalVariables.sharedInstance.update(value: .units, toNewValue: units)
    }
    
    func getLocationsFromCoreData() {
        cityData = coreDataManager.getAllCityData()
    }
    
}



