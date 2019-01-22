//
//  SettingsViewModel.swift
//  WeatherApp_V5
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

final class SettingsViewModel {
    
    fileprivate let model: SettingsModel
    
    fileprivate let constants = GlobalVariables.sharedInstance
//    fileprivate var savedLanguage = ""
//    fileprivate var savedUnits = ""
    
    
    init(withModel model: SettingsModel) {
        self.model = model
//        savedLanguage = constants.getDefaultLongName(value: .language)
//        savedUnits = constants.getDefaultLongName(value: .units)
    }
    
    func numberOfSections() -> Int {
        return model.settings.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return model.settings[section].items.count
    }
    
    func settingItemForIndexPath(_ indexPath: IndexPath) -> SettingItem {
        let section = model.settings[indexPath.section]
        return section.items[indexPath.item]
    }
    
    func settingHeaderTitle(_ section: Int) -> String {
        return model.settings[section].name
    }
    
    
}
