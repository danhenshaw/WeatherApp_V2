//
//  MainForecastViewModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

final class MainForecastViewModel {
    
    fileprivate let model: MainForecastModel
        
    init(withModel model: MainForecastModel) {
        self.model = model
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return model.cityData.count
    }
    
    func dataForIndexPath(_ index: Int) -> CityDataModel {
        let city = model.cityData[index]
        return city
    }
    
}
