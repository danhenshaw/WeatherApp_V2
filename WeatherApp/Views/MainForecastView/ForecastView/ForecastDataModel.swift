//
//  ForecastDataModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 20/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

class ForecastDataModel {
    
    fileprivate var cityData: CityDataModel
    fileprivate var forecast: ForecastModel?
    
    init(forCity cityData: CityDataModel) {
        self.cityData = cityData
    }
    
    func returnCityData() -> CityDataModel {
        return cityData
    }
    
    func returnForecast() -> ForecastModel? {
        if let forecast = forecast { return forecast } else { return nil }
    }
    
    func removeForecast() {
        forecast = nil
    }
    
    func updateForecast(_ retrievedForecast: ForecastModel) {
        forecast = retrievedForecast
    }
    
    func updateCityName(_ cityName: String) {
        cityData.cityName = cityName
    }
    
    func isForecastNil() -> Bool {
        if forecast == nil { return true } else { return false }
    }
    
    func updateCityData(_ location: CityDataModel) {
        cityData = location
    }
    
    func removeCityData() {
        let clearCityData = CityDataModel()
        clearCityData.cityName = ""
        clearCityData.latitude = 0
        clearCityData.longitude = 0
        clearCityData.isCurrentLocation = false
        cityData = clearCityData
    }
}
