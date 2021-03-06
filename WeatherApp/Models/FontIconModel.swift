//
//  FontIconModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 2/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

class FontIconModel {
    
    func updateMoonIcon(condition: Double) -> String {
        
        switch (condition) {
            
        case 0...0.1 : return "New Moon"
        case 0.11...0.19 : return "Waxing Crescent"
        case 0.2...0.3 : return "First Quarter"
        case 0.31...0.49 : return "Waxing Gibbous"
        case 0.5...0.6 : return "Full Moon"
        case 0.61...0.69 : return "Waning Gibbous"
        case 0.7...0.8 : return "Third Quarter"
        case 0.81...0.99 : return "Waning Crescent"
            
        default : return ""
        }
    }
    
    func updateWeatherIcon(condition: String, moonValue: Double) -> String {
        
        switch (condition) {
            
        case "clear-day" : return "I"
        case "clear-night" :
            
            switch moonValue {
            case 0...0.123 : return "O" // "New Moon"
            case 0.124 ... 0.246 : return "P" // "Waxing Crescent"
            case 0.247...0.369 : return "Q" // "First Quarter"
            case 0.370 ... 0.492 : return "R" // "Waxing Gibbous"
            case 0.493 ... 0.615 : return "S" // "Full Moon"
            case 0.616 ... 0.738 : return "T" // "Waning Gibbous"
            case 0.739 ... 0.832 : return "U" // "Third Quarter"
            case 0.833 ... 0.955 : return "V" // "Waning Crescent"
            case 0.956 ... 1 : return "O" // "New Moon"
            default : return "I"
            }
            
        case "partly-cloudy-day" : return  "\""
        case "partly-cloudy-night" : return  "\""
        case "cloudy" : return  "!"
        case "rain" : return  "$"
        case "sleet" : return  "0"
        case "snow" : return "9"
        case "wind" : return "B"
        case "fog" : return "<"
        case "sunset" : return "J"
        case "sunrise" : return "K"
            
            //            case "unknown" : return "~"
            //            case "cloud" : return  "!"
            //            case "cloudSun" : return  "'"
            //            case "cloudMoon" : return  "#"
            //            case "rain" : return  "$"
            //            case "rainSun" : return  "%"
            //            case "rainMoon" : return  "&"
            //            case "showers" : return  "'"
            //            case "showersSun" : return  "("
            //            case "showersMoon" : return  ")"
            //            case "downpour" : return  "*"
            //            case "downpourSun" : return  "+"
            //            case "downpourMoon" : return  " "
            //            case "drizzle" : return  "-"
            //            case "drizzleSun" : return  "."
            //            case "drizzleMoon" : return  "/"
            //            case "sleet" : return  "0"
            //            case "sleetSun" : return  "1"
            //            case "sleetMoon" : return  "2"
            //            case "hail" : return "3"
            //            case "hailSun" : return "4"
            //            case "hailMoon" : return "5"
            //            case "flurries" : return "6"
            //            case "flurriesSun" : return "7"
            //            case "flurriesMoon" : return "8"
            //            case "snow" : return "9"
            //            case "snowSun" : return ":"
            //            case "snowMoon" : return ";"
            //            case "fog" : return "<"
            //            case "fogSun" : return "="
            //            case "fogMoon" : return ">"
            //            case "haze" : return "?"
            //            case "hazeSun" : return "@"
            //            case "hazeMoon" : return "A"
            //            case "wind" : return "B"
            //            case "windcloud" : return "C"
            //            case "windcloudSun" : return "D"
            //            case "windcloudMoon" : return "E"
            //            case "lightning" : return "F"
            //            case "lightningSun" : return "G"
            //            case "lightningMoon" : return "H"
            //            case "sun" : return "I"
            //            case "sunset" : return "J"
            //            case "sunrise" : return "K"
            //            case "sunLow" : return "L"
            //            case "sunLower" : return "M"
            //            case "moon" : return "N"
//                        case "moonNew" : return "O"
//                        case "moonWaxingCrescent" : return "P"
//                        case "moonWaxingQuarter" : return "Q"
//                        case "moonWaxingGibbous" : return "R"
//                        case "moonFull" : return "S"
//                        case "moonWaningGibbous" : return "T"
//                        case "moonWaningQuarter" : return "U"
//                        case "moonWaningCrescent" : return "V"
            //            case "snowflake" : return "W"
            //            case "tornado" : return "X"
            //            case "thermometer" : return "Y"
            //            case "thermometerLow" : return "Z"
            //            case "thermometerMediumLow" : return "["
            //            case "thermometerMediumHigh" : return "\\"
            //            case "thermometerHigh" : return "]"
            //            case "thermometerFull" : return "^"
            //            case "celsius" : return "_"
            //            case "fahrenheit" : return "`"
            //            case "compass" : return "a"
            //            case "compassNorth" : return "b"
            //            case "compassEast" : return "c"
            //            case "compassSouth" : return "d"
            //            case "compassWest" : return "e"
            //            case "umbrella" : return "f"
            //            case "sunglasses" : return "g"
            //            case "cloudRefresh" : return "h"
            //            case "cloudUp" : return "i"
            //            case "cloudDown" : return "j"
            
        default : return ""
        }
    }
}
