//
//  PickerViewModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

final class PickerViewModel {
    
    fileprivate let model: PickerModel
    
    init(withModel model: PickerModel) {
        self.model = model
    }
    
    func numberOfItemsInSection(_ pickerType: PickerType) -> Int {
        switch pickerType {
        case .units : return model.units.count
        case .language : return model.language.count
        case .forecast : return model.forecast.count
        }
    }
    
    func valueItemForIndexPath(_ pickerType: PickerType, index: Int) -> PickerItem {
        switch pickerType {
        case .units : return model.units[index]
        case .language : return model.language[index]
        case .forecast : return model.forecast[index]
        }
    }

    func setScrollPosition(_ pickerType: PickerType) -> Int {
        
        var scrollPosition = 0
        
        switch pickerType {
        case .units :
        
        let savedUnits = GlobalVariables.sharedInstance.units
            for index in 0 ..< model.units.count {
                if model.units[index].shortName == savedUnits {
                    scrollPosition = index
                    break
                }
            }

        case .language :
        
        let savedLanguage = GlobalVariables.sharedInstance.language
            for index in 0 ..< model.language.count {
                if model.language[index].shortName == savedLanguage {
                    scrollPosition = index
                    break
                }
            }
            
        case .forecast : scrollPosition = 0
        }
        return scrollPosition
    }
}
