//
//  ForecastViewModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 20/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation
import UIKit

final class ForecastViewModel {
    
    fileprivate let model: ForecastDataModel
    fileprivate var forecast: ForecastModel?
    
    var isDownloadingForecast = false
    var failedToDownloadForecast = false
    fileprivate var forecastLastUpdatedAt = Double()
    
    init(withModel model: ForecastDataModel) {
        self.model = model
    }
    
    func getCityData() -> (cityName: String, latitude: Double, longitude: Double) {
        let city = model.cityData
        return (city.cityName, city.latitude, city.longitude)
    }
    
    func updateForecast(with newForecast: ForecastModel) {
        forecast = newForecast
        forecastLastUpdatedAt = Date().timeIntervalSince1970
    }
    
    func hasDownloadedForecast() -> Bool {
        if forecast == nil { return false } else { return true }
    }

    
    // Check to see if we should update the forecast. Implemented so that users cannot continuously download the same forecast
    func shouldUpdateForecast() -> Bool {
        
        // At leaset 10 seconds should pass before users try and download the weather again after the last failed download attempt
        let sufficientTimeSinceLastFailedDownload = NSDate().timeIntervalSince1970 >= forecastLastUpdatedAt + 10
        
        // At least 2 hours should pass before users try and download the weather again after we last successfully downloaded the weather
        let sufficientTimeSinceLastSuccessfullDownload = NSDate().timeIntervalSince1970 >= forecastLastUpdatedAt + 2 * 60 * 60
        
        if GlobalVariables.sharedInstance.settingsHaveChanged { return true }
        else if isDownloadingForecast { return false }
        else if failedToDownloadForecast && !sufficientTimeSinceLastFailedDownload { return false }
        else if hasDownloadedForecast() && !sufficientTimeSinceLastSuccessfullDownload { return false }
        else { return true }
    }
    
    
    // Algorithm that currently checkes the selected weather icon and returns a gradient.
    // Future updates will include a more complex algorithm that may check time, temperature, precipitation etc.
    func generateBackgroundGradient(forecastSection: ForecastSection, index: Int) -> [CGColor] {
        
        var condition = ""
        
        switch forecastSection {
        case .hourly : condition = forecast?.hourly?.data[index].icon ?? ""
        case .daily : condition = forecast?.daily?.data[index].icon ?? ""
        default : condition = forecast?.currently?.icon ?? ""
        }
        
        switch condition {
        case "clear-day" : return [UIColor(rgb: 0x2196f3, a: 1).cgColor, UIColor(rgb: 0xf44336, a: 1).cgColor]
        case "clear-night" : return [UIColor(rgb: 0x000428, a: 1).cgColor, UIColor(rgb: 0x004e92, a: 1).cgColor]
        case "partly-cloudy-day" : return [UIColor(rgb: 0x114357, a: 1).cgColor, UIColor(rgb: 0xf29492, a: 1).cgColor]
        case "partly-cloudy-night" : return [UIColor(rgb: 0x141e30, a: 1).cgColor, UIColor(rgb: 0x243b55, a: 1).cgColor]
        case "cloudy" : return [UIColor(rgb: 0x4b79a1, a: 1).cgColor, UIColor(rgb: 0x283e51, a: 1).cgColor]
        case "rain" : return [UIColor(rgb: 0x0b8793, a: 1).cgColor, UIColor(rgb: 0x360033, a: 1).cgColor]
        case "sleet" : return [UIColor(rgb: 0x1f1c2c, a: 1).cgColor, UIColor(rgb: 0x928dab, a: 1).cgColor]
        case "snow" : return [UIColor(rgb: 0xdc2424, a: 1).cgColor, UIColor(rgb: 0x4a569d, a: 1).cgColor]
        case "wind" : return [UIColor(rgb: 0xde6161, a: 1).cgColor, UIColor(rgb: 0x2657eb, a: 1).cgColor]
        case "fog" : return [UIColor(rgb: 0x283048, a: 1).cgColor, UIColor(rgb: 0x859398, a: 1).cgColor]
        default: return [UIColor(rgb: 0x4b6cb7, a: 1).cgColor, UIColor(rgb: 0x182848, a: 1).cgColor]
        }
    }
    
    
    // Format forecast data for city to be used in the Location List view
    func prepareLocationListData() -> LocationListItem {
        let timeZone = forecast?.timezone ?? ""
        let locationListData = LocationListItem()
        locationListData.cityName = model.cityData.cityName
        locationListData.longitude = model.cityData.longitude
        locationListData.latitude = model.cityData.latitude
        locationListData.temp = forecast?.currently?.getValueString(dataType: "temp", timeZone: timeZone).value
        locationListData.summary = forecast?.currently?.summary
        locationListData.time = forecast?.currently?.getValueString(dataType: "time", timeZone: timeZone).value
        locationListData.isCurrentLocation = model.cityData.isCurrentLocation
        
        let currentTime = forecast?.currently?.time ?? 0
        let sunriseTime = forecast?.daily?.data[0].sunriseTime ?? 0
        let sunsetTime = forecast?.daily?.data[0].sunsetTime ?? 0
        
        if currentTime <= sunriseTime || currentTime >= sunsetTime {
            locationListData.isBackgroundDark = true
        } else {
            locationListData.isBackgroundDark = false
        }
        
        return locationListData
    }
    
    

    // Format the forecast data required for the title cell
    func prepareTitleCellData(forecastSection: ForecastSection, index: Int) -> TitleCellItem {
        
        var time = ""
        let timeZone = forecast?.timezone ?? ""
        
        switch forecastSection {
        case .hourly :
            let timeString = forecast?.hourly?.getValueString(dataType: "time", index: index, timeZone: timeZone).value ?? "Forecast currently unavailable."
            if timeString != "Forecast currently unavailable." { time = "Forecast for " + timeString }
            
        case .daily :
            let timeString = forecast?.daily?.getValueString(dataType: "time", index: index, timeZone: timeZone).value ?? "Forecast currently unavailable."
            if timeString != "Forecast currently unavailable." { time = "Forecast for " + timeString }
            
        default :
            let timeString = forecast?.currently?.getValueString(dataType: "time", timeZone: timeZone).value ?? "Forecast currently unavailable."
            if timeString != "Forecast currently unavailable." { time = "Last updated: " + timeString }
        }

        return TitleCellItem(cityName: model.cityData.cityName, time: time)
    }
    
    
    
    // Format the forecast data required for the overview cell
    func prepareForecastOverviewCellData(forecastSection: ForecastSection, index: Int) -> ForecastOverviewCellItem {
        
        var cellData: ForecastOverviewCellItem
        let timeZone = forecast?.timezone ?? ""
        let defaultCell = LabelFormat(title: "", value: "")
        let data = GlobalVariables.sharedInstance
        
        switch forecastSection {
        case .currently :
            
            cellData = ForecastOverviewCellItem(currentTemp: forecast?.currently?.getValueString(dataType: data.currentlyData[0], timeZone: timeZone).value ?? "",
                                                values: [forecast?.currently?.getValueString(dataType: data.currentlyData[1], timeZone: timeZone) ?? defaultCell,
                                                         forecast?.currently?.getValueString(dataType: data.currentlyData[2], timeZone: timeZone) ?? defaultCell,
                                                         forecast?.currently?.getValueString(dataType: data.currentlyData[3], timeZone: timeZone) ?? defaultCell,
                                                         forecast?.currently?.getValueString(dataType: data.currentlyData[4], timeZone: timeZone) ?? defaultCell])
            
        case .hourly :
            
            cellData = ForecastOverviewCellItem(currentTemp: nil,
                                                values: [forecast?.hourly?.getValueString(dataType: data.hourlyData[0], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.hourly?.getValueString(dataType: data.hourlyData[1], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.hourly?.getValueString(dataType: data.hourlyData[2], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.hourly?.getValueString(dataType: data.hourlyData[3], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.hourly?.getValueString(dataType: data.hourlyData[4], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.hourly?.getValueString(dataType: data.hourlyData[5], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.hourly?.getValueString(dataType: data.hourlyData[6], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.hourly?.getValueString(dataType: data.hourlyData[7], index: index, timeZone: timeZone) ?? defaultCell])
            
        // Default value is set to return daily forecast data
        default :
            
            cellData = ForecastOverviewCellItem(currentTemp: nil,
                                                values: [forecast?.daily?.getValueString(dataType: data.dailyData[0], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.daily?.getValueString(dataType: data.dailyData[1], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.daily?.getValueString(dataType: data.dailyData[2], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.daily?.getValueString(dataType: data.dailyData[3], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.daily?.getValueString(dataType: data.dailyData[4], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.daily?.getValueString(dataType: data.dailyData[5], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.daily?.getValueString(dataType: data.dailyData[6], index: index, timeZone: timeZone) ?? defaultCell,
                                                         forecast?.daily?.getValueString(dataType: data.dailyData[7], index: index, timeZone: timeZone) ?? defaultCell])
        }
        
        return cellData
    }
    
    
    // Format the forecast data required for the minutely cell which display either the selected summary or minutely forecast information for the next 60 mins when available
    
    func prepareMinutelyForecastCellData(forecastSection: ForecastSection, index: Int) -> MinutelyForecastCellItem {
        
        var summary = ""
        var minutelyForecastAvailable = true
        var barHeightArray = [Double]()
        
        switch forecastSection {
        case .hourly : summary = forecast?.hourly?.data[index].summary ?? ""
        case .daily : summary = forecast?.daily?.data[index].summary ?? ""
        default : summary = forecast?.currently?.summary ?? ""
        }
        
        let itemCount = forecast?.minutely?.data.count ?? 0
        
        if itemCount == 0 {
            minutelyForecastAvailable = false
        }
        
        for index in 0 ..< itemCount {
            
            let intensity = forecast?.minutely?.data[index].precipIntensity ?? 0
            let type = forecast?.minutely?.data[index].precipType ?? ""
            
            let barHeight = PrecipIntensityModel.sharedInstance.getIntensit(intensity: intensity, type: type)
            barHeightArray.append(barHeight)
            
        }
        
        let cellData = MinutelyForecastCellItem(summary: summary, cityName: model.cityData.cityName, barHeight: barHeightArray, minutelyForecastAvailable: minutelyForecastAvailable, section: forecastSection)
        return cellData
        
    }
    
    
    
    // Format the forecast data required for the selectable hourly or daily cell
    func prepareHourlyOrDailyCellData(forecastSection: ForecastSection) -> [HourlyOrDailyForecastCellItem] {
        var cellData = [HourlyOrDailyForecastCellItem]()
        var itemCount = 0
        
        let weeklyMax = weeklyTemperatureExtremes().temperatureHighMax
        let weeklyMaxLow = weeklyTemperatureExtremes().temperatureHighMin
        let weeklyMin = weeklyTemperatureExtremes().temperatureLowMax
        let weeklyMinLow = weeklyTemperatureExtremes().temperatureLowMin
        let twoDayMax = twoDayMaxMin().max
        let twoDayMin = twoDayMaxMin().min
        
        if forecastSection == .daily {
            itemCount = forecast?.daily?.data.count ?? 0
            for index in 0 ..< itemCount {
                let dayData = HourlyOrDailyForecastCellItem(precip: forecast?.daily?.data[index].precipProbability ?? 0,
                                                            maxTemp: forecast?.daily?.data[index].temperatureHigh ?? 0,
                                                            minTemp: forecast?.daily?.data[index].temperatureLow ?? 0,
                                                            icon: FontIconModel().updateWeatherIcon(condition: forecast?.daily?.data[index].icon ?? "",
                                                                                             moonValue: forecast?.daily?.data[index].moonPhase ?? 0.0),
                                                            day: FormatDate().date(unixtimeInterval: forecast?.daily?.data[index].time ?? 0,
                                                                                 timeZone: forecast?.timezone ?? "",
                                                                                 format: .day),
                                                            rangeMax: weeklyMax,
                                                            rangeMaxLow: weeklyMaxLow,
                                                            rangeMin: weeklyMin,
                                                            rangeMinLow: weeklyMinLow)
                
                cellData.append(dayData)
            }
            
        } else {
            itemCount = forecast?.hourly?.data.count ?? 0
            for index in 0 ..< itemCount {
                var dayForMoon = 0
                if index <= 24 { dayForMoon = 0 } else { dayForMoon = 1 }
                let hourData = HourlyOrDailyForecastCellItem(precip: forecast?.hourly?.data[index].precipProbability ?? 0,
                                                             maxTemp: forecast?.hourly?.data[index].temperature ?? 0,
                                                             minTemp: nil,
                                                             icon: FontIconModel().updateWeatherIcon(condition: forecast?.hourly?.data[index].icon ?? "",
                                                                                              moonValue: forecast?.daily?.data[dayForMoon].moonPhase ?? 0.0),
                                                             day: FormatDate().date(unixtimeInterval: forecast?.hourly?.data[index].time ?? 0,
                                                                                  timeZone: forecast?.timezone ?? "",
                                                                                  format: .timeShort),
                                                             rangeMax: twoDayMax,
                                                             rangeMaxLow: weeklyMaxLow,
                                                             rangeMin: twoDayMin,
                                                             rangeMinLow: weeklyMinLow)
                
                cellData.append(hourData)
            }
            
        }
        
        return cellData
        
    }
    
    
    
    // Return the max/min high temperature and max/min low temperature for the week
    func weeklyTemperatureExtremes() -> (temperatureHighMax: Double, temperatureHighMin: Double, temperatureLowMax: Double, temperatureLowMin: Double) {
        
        let itemCount = forecast?.daily?.data.count ?? 0
        
        var temperatureHighArray = [Double]()
        var temperatureLowArray = [Double]()
        
        for index in 0 ..< itemCount {
            temperatureHighArray.append(forecast?.daily?.data[index].temperatureHigh ?? 0.0)
            temperatureLowArray.append(forecast?.daily?.data[index].temperatureLow ?? 0.0)
        }
        
        let temperatureHighMax = temperatureHighArray.max()
        let temperatureHighMin = temperatureHighArray.min()
        let temperatureLowMax = temperatureLowArray.max()
        let temperatureLowMin = temperatureLowArray.min()
        
        return (temperatureHighMax ?? 0, temperatureHighMin ?? 0, temperatureLowMax ?? 0, temperatureLowMin ?? 0)

    }
    
    
    
    // return the max and min temperature for the next 48 hours
    func twoDayMaxMin() -> (max: Double, min: Double) {
        
        var temperatureArray = [Double]()
        let itemCount = forecast?.hourly?.data.count ?? 0
        
        for index in 0 ..< itemCount {
            temperatureArray.append(forecast?.hourly?.data[index].temperature ?? 0)

        }
        
        let max = temperatureArray.max()
        let min = temperatureArray.min()
        
        return (max ?? 0.0, min ?? 0.0)
    }
    
    
    
    
    
    
    
    
    
    

    
}
