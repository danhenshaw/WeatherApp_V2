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
    
    func numberOfItemsInSection(_ pickerType: PickerType, forecastSection: ForecastSection?, slot: Int?) -> Int {
        switch pickerType {
        case .units : return model.units.count
        case .language : return model.language.count
        case .forecast :
            if let forecastSection = forecastSection {
                switch forecastSection {
                case .daily : return model.forecastDaily.count
                case .hourly : return model.forecastHourly.count
                case .currently :
                    if let slot = slot {
                        switch slot {
                        case 0 : return model.forecastCurrentTemp.count
                        default : return model.forecastCurrently.count
                        }
                    }
                default : return 0
                }
            }
        }
        return 0
    }
    
    
    
    func valueItemForIndexPath(_ pickerType: PickerType, forecastSection: ForecastSection?, slot: Int?, index: Int) -> String {
        switch pickerType {
        case .units : return model.units[index]
        case .language : return model.language[index]
        case .forecast :
            if let forecastSection = forecastSection {
                switch forecastSection {
                case .daily : return model.forecastDaily[index]
                case .hourly : return model.forecastHourly[index]
                case .currently :
                    if let slot = slot {
                        switch slot {
                        case 0 : return model.forecastCurrentTemp[index]
                        default : return model.forecastCurrently[index]
                        }
                    }
                default : return "--"
                }
            }
        }
        return "--"
    }


    
    func setScrollPosition(_ pickerType: PickerType, forecastSection: ForecastSection?, slot: Int?) -> Int {
        
        var scrollPosition = 0
        
        switch pickerType {
        case .units :
        
        let savedUnits = GlobalVariables.sharedInstance.units
            for index in 0 ..< model.units.count {
                if model.units[index] == savedUnits {
                    scrollPosition = index
                    break
                }
            }

        case .language :
        
        let savedLanguage = GlobalVariables.sharedInstance.language
            for index in 0 ..< model.language.count {
                if model.language[index] == savedLanguage {
                    scrollPosition = index
                    break
                }
            }
            
        case .forecast :
            
            if let forecastSection = forecastSection {
                if let slot = slot {
                    switch forecastSection {
                    case .daily :
                    
                    let savedDataType = GlobalVariables.sharedInstance.dailyData[slot]
                    
                    for index in 0 ..< model.forecastDaily.count {
                        if model.forecastDaily[index] == savedDataType {
                            scrollPosition = index
                            break
                        }
                    }
                    
                case .hourly :
                    
                    let savedDataType = GlobalVariables.sharedInstance.hourlyData[slot]
                    
                    for index in 0 ..< model.forecastHourly.count {
                        if model.forecastHourly[index] == savedDataType {
                            scrollPosition = index
                            break
                        }
                    }
                    
                case .currently :
                    
                    let savedDataType = GlobalVariables.sharedInstance.currentlyData[slot]
                    
                    if slot == 0 {
                        for index in 0 ..< model.forecastCurrentTemp.count {
                            if model.forecastCurrentTemp[index] == savedDataType {
                                scrollPosition = index
                                break
                            }
                        }
                    } else {
                        for index in 0 ..< model.forecastCurrently.count {
                            if model.forecastCurrently[index] == savedDataType {
                                scrollPosition = index
                                break
                            }
                        }
                    }
                    default: break
                    }
                }
            }
        }
        return scrollPosition
    }
        
        
        
        
        
}
