//
//  DailyForecastDataModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 29/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

enum DailyForecastDataType {
    case time, sunriseTime, sunsetTime, moonPhase, precipIntensity, precipProbability, dewPoint, humidity, pressure, wind, cloudCover, uvIndex, visibility, ozone, temp, feelsLike 
}

struct DailyData: Codable {
    var time: Int?
    var summary: String?
    var icon: String?
    var sunriseTime: Int?
    var sunsetTime: Int?
    var moonPhase: Double?
    var precipIntensity: Double?
    var precipIntensityMax: Double?
    var precipIntensityMaxTime: Int?
    var precipProbability: Double?
    var precipType: String?
    var temperatureHigh: Double?
    var temperatureHighTime: Int?
    var temperatureLow: Double?
    var temperatureLowTime: Int?
    var apparentTemperatureHigh: Double?
    var apparentTemperatureHighTime: Int?
    var apparentTemperatureLow: Double?
    var apparentTemperatureLowTime: Int?
    var dewPoint: Double?
    var humidity: Double?
    var pressure: Double?
    var windSpeed: Double?
    var windGust: Double?
    var windGustTime: Int?
    var windBearing: Double?
    var cloudCover: Double?
    var uvIndex: Int?
    var uvIndexTime: Int?
    var visibility: Float?
    var ozone: Double?
}

struct Daily: Codable {
    var summary: String?
    var icon: String?
    var data: [DailyData]
    
    
    func getValueString(dataType: DailyForecastDataType, index: Int, timeZone: String) -> LabelFormat {
        
        var titleLabelText = ""
        var valueLabelText = ""
        
        let formatdate = FormatDate()
        let moonPhase = FontIconModel()
        
        switch dataType {
        case .time :
            titleLabelText = "TIME: "
            valueLabelText = formatdate.date(unixtimeInterval: data[index].time ?? 0, timeZone: timeZone, format: .medium)
        case .sunriseTime :
            titleLabelText = "SUNRISE: "
            valueLabelText = formatdate.date(unixtimeInterval: data[index].sunriseTime ?? 0, timeZone: timeZone, format: .timeLong)
        case .sunsetTime :
            titleLabelText = "SUNSET: "
            valueLabelText = formatdate.date(unixtimeInterval: data[index].sunsetTime ?? 0, timeZone: timeZone, format: .timeLong)
        case .moonPhase :
            titleLabelText = "MOON: "
            valueLabelText = moonPhase.updateMoonIcon(condition: data[index].moonPhase ?? 0.0)
        case .precipIntensity :
            titleLabelText = "\((data[index].precipType)?.uppercased() ?? "PRECIP"): "
            let value = "\(data[index].precipIntensity ?? 0)" 
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .rainfall)
            valueLabelText = value + " " + units
        case .precipProbability :
            titleLabelText = "\((data[index].precipType)?.uppercased() ?? "PRECIP"): "
            valueLabelText = "\(Int(round((data[index].precipProbability ?? 0.0) * 100)))%"
        case .temp :
            titleLabelText = "TEMP: "
            let tempHigh = "↑ " + "\(Int(round(data[index].temperatureHigh ?? 0.0)))°"
            let tempLow = "↓ " + "\(Int(round(data[index].temperatureLow ?? 0.0)))°"
            valueLabelText = tempHigh + " " + tempLow
        case . feelsLike :
            titleLabelText = "FEELS LIKE: "
            let tempHigh = "↑ " + "\(Int(round(data[index].apparentTemperatureHigh ?? 0.0)))°"
            let tempLow = "↓ " + "\(Int(round(data[index].apparentTemperatureLow ?? 0.0)))°"
            valueLabelText = tempHigh + " " + tempLow
        case .dewPoint :
            titleLabelText = "DEW POINT: "
            valueLabelText = "\(Int(round(data[index].dewPoint ?? 0.0)))°"
        case .humidity :
            titleLabelText = "HUMIDITY: "
            valueLabelText = "\(Int(round((data[index].humidity ?? 0.0) * 100)))%"
        case .pressure :
            titleLabelText = "PRESSURE: "
            let value = "\(Int(round(data[index].pressure ?? 0.0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .pressure)
            valueLabelText = value + " " + units
        case .wind :
            titleLabelText = "WIND: "
            let direction = getDirection(value: Int(round(data[index].windBearing ?? 0.0)))
            let speed = "\(Int(round(data[index].windSpeed ?? 0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .wind)
            valueLabelText = direction + " " + speed + " " + units
        case .cloudCover :
            titleLabelText = "CLOUDS: "
            valueLabelText = "\(Int(round((data[index].cloudCover ?? 0) * 100)))%"
        case .uvIndex :
            titleLabelText = "UV INDEX: "
            valueLabelText = "\(data[index].uvIndex ?? 0)"
        case .visibility :
            titleLabelText = "VISIBILITY: "
            let value = "\(Int(round(data[index].visibility ?? 0.0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .distance)
            valueLabelText = value + " " + units
        case .ozone :
            titleLabelText = "OZONE: "
            valueLabelText = "\(data[index].ozone ?? 0.0)"
        }
        
        return LabelFormat(title: titleLabelText, value: valueLabelText)
    }
    
    
    
    
    func getDirection(value: Int) -> String {
        switch value {
        case 0 ... 22 : return "N"
        case 23 ... 67 : return "NE"
        case 68 ... 112 : return "E"
        case 113 ... 157 : return "SE"
        case 158 ... 202 : return "S"
        case 203 ... 247 : return "SW"
        case 248 ... 292 : return "W"
        case 293 ... 337 : return "NW"
        case 338 ... 360 : return "N"
        default : return ""
        }
    }
    
    
}