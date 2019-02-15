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
    
    var isDownloadingForecast = false
    var failedToDownloadForecast = false
    var pageIndex: Int
    fileprivate var forecastLastUpdatedAt = Double()
    
    init(withModel model: ForecastDataModel, pageIndex: Int) {
        self.model = model
        self.pageIndex = pageIndex
    }
    
    func getCityData() -> CityDataModel? {
        if model.returnCityData().longitude == 0 && model.returnCityData().latitude == 0 {
            return nil
        } else {
            return model.returnCityData()
        }
    }
    
    func updateCityName(cityName: String) {
        model.updateCityName(cityName)
    }
    
    func updateCurrentLocation(_ location: CityDataModel) {
        model.updateCityData(location)
    }
    
    func removeCityData() {
        model.removeCityData()
    }
    
    func updateForecast(with newForecast: ForecastModel) {
        model.updateForecast(newForecast)
        forecastLastUpdatedAt = Date().timeIntervalSince1970
    }
    
    func removeForecast() {
        model.removeForecast()
    }
    
    func hasDownloadedForecast() -> Bool {
        if model.isForecastNil() { return false } else {return true }
    }

    
    // Check to see if we should update the forecast. Implemented so that users cannot continuously download the same forecast
    func shouldUpdateForecast() -> Bool {
        
        // At leaset 10 seconds should pass before users try and download the weather again after the last failed download attempt
        let sufficientTimeSinceLastFailedDownload = NSDate().timeIntervalSince1970 >= forecastLastUpdatedAt + 10
        
        // At least 2 hours should pass before users try and download the weather again after we last successfully downloaded the weather
        let sufficientTimeSinceLastSuccessfullDownload = NSDate().timeIntervalSince1970 >= forecastLastUpdatedAt + 2 * 60 * 60
        
        if isDownloadingForecast { return false }
        else if failedToDownloadForecast && !sufficientTimeSinceLastFailedDownload { return false }
        else if hasDownloadedForecast() && !sufficientTimeSinceLastSuccessfullDownload { return false }
        else if getCityData() == nil { return false }
        else { return true }
    }
    
    
    // Algorithm that currently checkes the selected weather icon and returns a gradient.
    // Future updates will include a more complex algorithm that may check time, temperature, precipitation etc.
    func generateBackgroundGradient(forecastSection: ForecastSection, index: Int) -> [CGColor] {
        
        var condition = ""
        let forecast : ForecastModel? = model.returnForecast()
        
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
        let forecast : ForecastModel? = model.returnForecast()
        let timeZone = forecast?.timezone ?? ""
        let locationListData = LocationListItem()
        locationListData.cityName = model.returnCityData().cityName
        locationListData.longitude = model.returnCityData().longitude
        locationListData.latitude = model.returnCityData().latitude
        locationListData.temp = forecast?.currently?.getValueString(dataType: "temp", timeZone: timeZone).value
        locationListData.summary = forecast?.currently?.summary
        locationListData.time = FormatDate().date(unixtimeInterval: (Int(Date().timeIntervalSince1970)), timeZone: timeZone, format: .mediumWithTime)
        locationListData.isCurrentLocation = model.returnCityData().isCurrentLocation
        
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
        let forecast : ForecastModel? = model.returnForecast()
        if let timeZone = forecast?.timezone {
        
            switch forecastSection {
            case .hourly : time = forecast?.hourly?.getValueString(dataType: "time", index: index, timeZone: timeZone).value ?? ""
            case .daily : time = forecast?.daily?.getValueString(dataType: "time", index: index, timeZone: timeZone).value ?? ""
            default : time = FormatDate().date(unixtimeInterval: (Int(Date().timeIntervalSince1970)), timeZone: timeZone, format: .mediumWithTime)
            }
            return TitleCellItem(cityName: model.returnCityData().cityName, time: "Forecast for " + time)
            
        } else {
            return TitleCellItem(cityName: model.returnCityData().cityName, time: "")
        }
    }
    
    
    
    // Format the forecast data required for the overview cell
    func prepareForecastOverviewCellData(forecastSection: ForecastSection, index: Int) -> ForecastOverviewCellItem {
        
        var cellData: ForecastOverviewCellItem
        let forecast : ForecastModel? = model.returnForecast()
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
        
        let forecast : ForecastModel? = model.returnForecast()
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
        
        let cellData = MinutelyForecastCellItem(summary: summary, cityName: model.returnCityData().cityName, barHeight: barHeightArray, minutelyForecastAvailable: minutelyForecastAvailable, section: forecastSection)
        return cellData
        
    }
    
    // Format the forecast data required for the hourly collection view
    func prepareHourlyCellData() -> [HourlyOrDailyForecastCellItem] {
        
        let forecast : ForecastModel? = model.returnForecast()
        var cellData = [HourlyOrDailyForecastCellItem]()

        let twoDayMax = forecast?.hourly?.twoDayMaxMin().max
        let twoDayMin = forecast?.hourly?.twoDayMaxMin().min
        
        let  itemCount = forecast?.hourly?.data.count ?? 0
        
        for index in 0 ..< itemCount {
            
            // We check to see if the moon phase icon should be for today (>24 hours) or tomorrow (24-48 hours)
            var dayForMoon = 0
            if index <= 24 { dayForMoon = 0 } else { dayForMoon = 1 }
            
            let icon = FontIconModel().updateWeatherIcon(condition: forecast?.hourly?.data[index].icon ?? "", moonValue: forecast?.daily?.data[dayForMoon].moonPhase ?? 0.0)
            let time = FormatDate().date(unixtimeInterval: forecast?.hourly?.data[index].time ?? 0, timeZone: forecast?.timezone ?? "", format: .timeShort)
            let dayLong = FormatDate().date(unixtimeInterval: forecast?.hourly?.data[index].time ?? 0, timeZone: forecast?.timezone ?? "", format: .dayLong)
            let precip = forecast?.hourly?.data[index].precipProbability ?? 0
            let maxTemp = forecast?.hourly?.data[index].temperature ?? 0
            
            // time is "00" it indicates a new day so we should append additional data so this can be shown in the collection view
            if time == "00" {
                let hourData = HourlyOrDailyForecastCellItem(precip: 0, maxTemp: 0, minTemp: nil, icon: "", day: dayLong, rangeMax: 0, rangeMaxLow: nil, rangeMin: 0, rangeMinLow: nil, cellType: .newDay, index: nil)
                cellData.append(hourData)
            }
            
            // time interval is larger than day sunset value, append the sunrise sunset cell
            
            var sunriseTimes = forecast?.daily?.sunriseTimes() ?? [0]
            var sunsetTimes = forecast?.daily?.sunsetTimes() ?? [0]
            
            for time in 0 ..< sunriseTimes.count {
                if index != 0 {
                    if forecast?.hourly?.data[index].time ?? 0 >= sunriseTimes[time] && forecast?.hourly?.data[index - 1].time ?? 0 <= sunriseTimes[time] {
                        let sunriseTime = FormatDate().date(unixtimeInterval: sunriseTimes[time], timeZone: forecast?.timezone ?? "", format: .timeLong)
                        let hourData = HourlyOrDailyForecastCellItem(precip: precip, maxTemp: maxTemp, minTemp: nil, icon: "K", day: sunriseTime, rangeMax: twoDayMax ?? 0, rangeMaxLow: nil, rangeMin: twoDayMin ?? 0, rangeMinLow: nil, cellType: .sunrise, index: nil)
                        cellData.append(hourData)
                    }
                }
            }
            
            
            for time in 0 ..< sunsetTimes.count {
                if index != 0 {
                    if forecast?.hourly?.data[index].time ?? 0 >= sunsetTimes[time] && forecast?.hourly?.data[index - 1].time ?? 0 <= sunsetTimes[time] {
                        let sunsetTime = FormatDate().date(unixtimeInterval: sunsetTimes[time], timeZone: forecast?.timezone ?? "", format: .timeLong)
                        let hourData = HourlyOrDailyForecastCellItem(precip: precip, maxTemp: maxTemp, minTemp: nil, icon: "J", day: sunsetTime, rangeMax: twoDayMax ?? 0, rangeMaxLow: nil, rangeMin: twoDayMin ?? 0, rangeMinLow: nil, cellType: .sunset, index: nil)
                        cellData.append(hourData)
                    }
                }
            }
            
            
            
            let hourData = HourlyOrDailyForecastCellItem(precip: precip, maxTemp: maxTemp, minTemp: nil, icon: icon, day: time, rangeMax: twoDayMax ?? 0, rangeMaxLow: nil, rangeMin: twoDayMin ?? 0, rangeMinLow: nil, cellType: .hourly, index: index)
            
            cellData.append(hourData)
        }

        return cellData
        
    }
    
    
    // Format the forecast data required for the daily collection view
    func prepareDailyCellData() -> [HourlyOrDailyForecastCellItem] {
        let forecast : ForecastModel? = model.returnForecast()
        var cellData = [HourlyOrDailyForecastCellItem]()
        
        let weeklyMax = forecast?.daily?.weeklyTemperatureExtremes().temperatureHighMax
        let weeklyMaxLow = forecast?.daily?.weeklyTemperatureExtremes().temperatureHighMin
        let weeklyMin = forecast?.daily?.weeklyTemperatureExtremes().temperatureLowMax
        let weeklyMinLow = forecast?.daily?.weeklyTemperatureExtremes().temperatureLowMin
        
        let itemCount = forecast?.daily?.data.count ?? 0
        for index in 0 ..< itemCount {
            let dayData = HourlyOrDailyForecastCellItem(precip: forecast?.daily?.data[index].precipProbability ?? 0,
                                                        maxTemp: forecast?.daily?.data[index].temperatureHigh ?? 0,
                                                        minTemp: forecast?.daily?.data[index].temperatureLow ?? 0,
                                                        icon: FontIconModel().updateWeatherIcon(condition: forecast?.daily?.data[index].icon ?? "",
                                                                                         moonValue: forecast?.daily?.data[index].moonPhase ?? 0.0),
                                                        day: FormatDate().date(unixtimeInterval: forecast?.daily?.data[index].time ?? 0,
                                                                             timeZone: forecast?.timezone ?? "",
                                                                             format: .day),
                                                        rangeMax: weeklyMax ?? 0,
                                                        rangeMaxLow: weeklyMaxLow,
                                                        rangeMin: weeklyMin ?? 0,
                                                        rangeMinLow: weeklyMinLow,
                                                        cellType: .daily,
                                                        index: index)
            
            cellData.append(dayData)
        }
        return cellData
    }
    

    
}
