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
    fileprivate let translator = Translator()
    fileprivate let formatDate = FormatDate()
    fileprivate let fontIcon = FontIconModel()
    
    
    var isDownloadingForecast = false
    var failedToDownloadForecast = false
    var forecastLastUpdatedAt = Double()
    
    init(withModel model: ForecastDataModel) {
        self.model = model
    }
    
    func getCityData() -> (cityName: String, latitude: Double, longitude: Double) {
        let city = model.cityData
        return (city.cityName, city.latitude, city.longitude)
    }
    
    func updateForecast(with newForecast: ForecastModel) {
        forecast = newForecast
    }
    
    func hasDownloadedForecast() -> Bool {
        if forecast == nil {
            return false
        } else {
            return true
        }
    }

    
    
    func shouldUpdateForecast() -> Bool {
        
        let sufficientTimeSinceLastFailedDownload = NSDate().timeIntervalSince1970 >= forecastLastUpdatedAt + 10
        let sufficientTimeSinceLastSuccessfullDownload = NSDate().timeIntervalSince1970 >= forecastLastUpdatedAt + 2 * 60 * 60
        
        if GlobalVariables.sharedInstance.settingsHaveChanged { return true }
        else if isDownloadingForecast { return false }
        else if failedToDownloadForecast && !sufficientTimeSinceLastFailedDownload { return false }
        else if hasDownloadedForecast() && !sufficientTimeSinceLastSuccessfullDownload { return false }
        else { return true }
    }
    
    
    
    func prepareLocationListData() -> LocationListItem {
        let timeZone = forecast?.timezone ?? ""
        let locationListData = LocationListItem()
        locationListData.cityName = model.cityData.cityName
        locationListData.longitude = model.cityData.longitude
        locationListData.latitude = model.cityData.latitude
        locationListData.temp = forecast?.currently?.getValueString(dataType: .temp, timeZone: timeZone).value
        locationListData.summary = forecast?.currently?.summary
        locationListData.time = forecast?.currently?.getValueString(dataType: .time, timeZone: timeZone).value
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
    
    
    
    
    func prepareTitleCellData(forecastSection: ForecastSection, index: Int) -> TitleCellItem {
        
        var time = ""
        let timeZone = forecast?.timezone ?? ""
        
        switch forecastSection {
        case .hourly :
            let timeString = forecast?.hourly?.getValueString(dataType: .time, index: index, timeZone: timeZone).value ?? "Forecast currently unavailable."
            
            if timeString != "Forecast currently unavailable." {
                time = "Forecast for " + timeString
            }
            
        case .daily :
            let timeString = forecast?.daily?.getValueString(dataType: .time, index: index, timeZone: timeZone).value ?? "Forecast currently unavailable."
            
            if timeString != "Forecast currently unavailable." {
                time = "Forecast for " + timeString
            }
            
        default :
            let timeString = forecast?.currently?.getValueString(dataType: .time, timeZone: timeZone).value ?? "Forecast currently unavailable."
            
            if timeString != "Forecast currently unavailable." {
                time = "Last updated: " + timeString
            }
        }

        return TitleCellItem(cityName: model.cityData.cityName, time: time)
    }
    
    
    
    func weeklyMaxMin() -> (max: Double, maxLow: Double, min: Double, minLow: Double) {
        
        var max = 0.0
        var maxLow = 0.0
        var min = 0.0
        var minLow = 0.0
        
        let itemCount = forecast?.daily?.data.count ?? 0
        
        for index in 0 ..< itemCount {
            
            if index == 0 {
                max = forecast?.daily?.data[index].temperatureHigh ?? 0
                maxLow = forecast?.daily?.data[index].temperatureHigh ?? 0
                min = forecast?.daily?.data[index].temperatureLow ?? 0
                minLow = forecast?.daily?.data[index].temperatureLow ?? 0
            } else {
                
                let maxTemp = forecast?.daily?.data[index].temperatureHigh ?? 0
                let minTemp = forecast?.daily?.data[index].temperatureLow ?? 0
                
                if maxTemp > max { max = maxTemp }
                if maxTemp < maxLow { maxLow = maxTemp }
                
                if minTemp > min { min = minTemp }
                if minTemp < minLow { minLow = minTemp }
            }
        }
        
        return (max, maxLow, min, minLow)
    }
    
    
    
    func twoDayMaxMin() -> (max: Double, min: Double) {
        var max = 0.0
        var min = 0.0
        
        let itemCount = forecast?.hourly?.data.count ?? 0
        
        for index in 0 ..< itemCount {
            
            if index == 0 {
                max = forecast?.hourly?.data[index].temperature ?? 0
                min = forecast?.hourly?.data[index].temperature ?? 0
                
            } else {
                
                let temp = forecast?.hourly?.data[index].temperature ?? 0
                
                if temp > max { max = temp }
                
                if temp < min { min = temp }
            }
        }
        
        return (max, min)
    }
    
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
        
        default : // DEFAULT TO DAILY FORECAST
            
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
    
    
    
    
    func prepareHourlyOrDailyCellData(forecastSection: ForecastSection) -> [HourlyOrDailyForecastCellItem] {
        var cellData = [HourlyOrDailyForecastCellItem]()
        var itemCount = 0
        
        let weeklyMax = weeklyMaxMin().max
        let weeklyMaxLow = weeklyMaxMin().maxLow
        let weeklyMin = weeklyMaxMin().min
        let weeklyMinLow = weeklyMaxMin().minLow
        let twoDayMax = twoDayMaxMin().max
        let twoDayMin = twoDayMaxMin().min
        
        if forecastSection == .daily {
            itemCount = forecast?.daily?.data.count ?? 0
            for index in 0 ..< itemCount {
                let dayData = HourlyOrDailyForecastCellItem(precip: forecast?.daily?.data[index].precipProbability ?? 0,
                                                            maxTemp: forecast?.daily?.data[index].temperatureHigh ?? 0,
                                                            minTemp: forecast?.daily?.data[index].temperatureLow ?? 0,
                                                            icon: fontIcon.updateWeatherIcon(condition: forecast?.daily?.data[index].icon ?? "",
                                                                                             moonValue: forecast?.daily?.data[index].moonPhase ?? 0.0),
                                                            day: formatDate.date(unixtimeInterval: forecast?.daily?.data[index].time ?? 0,
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
                                                             icon: fontIcon.updateWeatherIcon(condition: forecast?.hourly?.data[index].icon ?? "",
                                                                                              moonValue: forecast?.daily?.data[dayForMoon].moonPhase ?? 0.0),
                                                             day: formatDate.date(unixtimeInterval: forecast?.hourly?.data[index].time ?? 0,
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
    
    
    
    

    
}
