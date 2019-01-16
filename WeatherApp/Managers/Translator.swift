//
//  Translator.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 31/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

enum Strings {
    case wind, humidity, dewPoint, uvIndex, visibility, pressure, feelsLike, low, high, language, units, celcius, farenheit, kilometersPerHour, milesPerHour, metersPerSecond, milimetersPerHour, inchesPerHour, kilometers, miles, pascals, mb
}


class Translator {

    static var sharedInstance = Translator()
    
    let wind = ["de": "Wind", "en": "Wind", "es": "Eólico", "fr": "Vent", "it": "Vento", "ja": "風", "nl": "Wind", "tr": "Rüzgar", "x-pig-latin": "Indway", "zh": "风", "zh-tw": "風"]
    
    let humidity = ["de": "Luftfeuchtigkeit", "en": "Humidity", "es": "Humedad", "fr": "Humidité", "it": "Umidità", "ja": "湿度", "nl": "Vochtigheid", "tr": "Nem", "x-pig-latin": "Umidityhay", "zh": "湿度", "zh-tw": "濕度"]
    
    let dewPoint = ["de": "Taupunkt", "en": "Dew Point", "es": "Punto de rocío", "fr": "Point de Rosée", "it": "Punto di Rugiada", "ja": "露点", "nl": "Dauwpunt", "tr": "Çiy Noktası", "x-pig-latin": "Ewday Pt", "zh": "露点", "zh-tw": "露點"]
    
    let uvIndex = ["de": "UV Index", "en": "UV Index", "es": "Índice UV", "fr": "Indice UV", "it": "Indice UV", "ja": "紫外線指数", "nl": "UV Index", "tr": "Ultraviyole Indeksi", "x-pig-latin": "UV Indexway", "zh": "紫外线指数", "zh-tw": "指數"]
    
    let visibility = ["de": "Sichtweite", "en": "Visibility", "es": "Visibilidad", "fr": "Visibilité", "it": "Visibilità", "ja": "可視性", "nl": "Zichtbaarheid", "tr": "Görünürlük", "x-pig-latin": "Isibilityway", "zh": "能见度", "zh-tw": "能見度"]
    
    let pressure = ["de": "Luftdruck", "en": "Pressure", "es": "Presión", "fr": "Pression", "it": "Pressione", "ja": "圧力", "nl": "Luchtdruk", "tr": "Basıncı", "x-pig-latin": "Essurepray", "zh": "气压", "zh-tw": "壓力"]
    
    let feelsLike = ["de": "Fühlt Sich An Wie", "en": "Feels Like", "es": "Se Siente Como", "fr": "Ressentie", "it": "Si Sente Come", "ja": "のように感じている", "nl": "Voelt Als", "tr": "Gibi Hissettiriyor", "x-pig-latin": "Eelsfay Ikelay", "zh": "感觉像", "zh-tw": "感覺像"]
    
    let low = ["de": "Niedrig", "en": "Low", "es": "Bajo", "fr": "Minimale", "it": "Basso", "ja": "低", "nl": "Laag", "tr": "Düşük", "x-pig-latin": "Owlay", "zh": "低", "zh-tw": "低溫"]
    
    let high = ["de": "Hoch", "en": "High", "es": "Alto", "fr": "Maximale", "it": "Alto", "ja": "高い", "nl": "Hoog", "tr": "Yüksek", "x-pig-latin": "Ighhay", "zh": "高", "zh-tw": "高溫"]
    
    let language = ["de": "Deutsch", "en": "English", "es": "Español", "fr": "Fançais", "it": "Italiano", "ja": "日本人", "nl": "Nederlands", "tr": "Türk", "x-pig-latin": "Igpay Atinlay", "zh": "汉字简化方案", "zh-tw": "漢字傳統方案"]
    
    let units = ["ca": "°C, km/h", "si": "°C, m/s", "uk2": "°C, mph", "us": "°F, mph"]
    
    
    
    let celcius = ["en" : "°C"]
    
    let farenheit = ["en": "°F"]
    
    let kilometersPerHour = ["en": "km/h"]
    
    let milesPerHour = ["en": "mph"]
    
    let metersPerSecond = ["en": "m/s"]
    
    let milimetersPerHour = ["en": "mm/h"]
    
    let inchesPerHour = ["en": "in/h"]
    
    let kilometers = ["en": "km"]
    
    let miles = ["en": "mi"]
    
    let pascals = ["en": "hPa"]
    
    let mb = ["en": "mb"]

    
    func getString(forLanguage: String, string: Strings) -> String {
        switch string {
        case .wind : return wind[forLanguage, default: "Wind"]
        case .humidity : return humidity[forLanguage, default: "Humidity"]
        case .dewPoint : return dewPoint[forLanguage, default: "Dew point"]
        case .uvIndex : return uvIndex[forLanguage, default: "UV Index"]
        case .visibility : return visibility[forLanguage, default: "Visibility"]
        case .pressure : return pressure[forLanguage, default: "Pressure"]
        case .feelsLike : return feelsLike[forLanguage, default: "Feels like"]
        case .low : return low[forLanguage, default: "Low"]
        case .high : return high[forLanguage, default: "High"]
        case .language : return language[forLanguage, default: ""]
        case .units : return units[forLanguage, default: "°F, mph"]
        case .celcius : return celcius[forLanguage, default: "°C"]
        case .farenheit : return farenheit[forLanguage, default: "°F"]
        case .kilometersPerHour : return kilometersPerHour[forLanguage, default: "km.h"]
        case .milesPerHour : return milesPerHour[forLanguage, default: "mph"]
        case .metersPerSecond : return metersPerSecond[forLanguage, default: "m/s"]
        case .milimetersPerHour : return milimetersPerHour[forLanguage, default: "mm/h"]
        case .inchesPerHour : return inchesPerHour[forLanguage, default: "in/h"]
        case .kilometers : return kilometers[forLanguage, default: "km"]
        case .miles : return miles[forLanguage, default: "mi"]
        case .pascals : return pascals[forLanguage, default: "hPa"]
        case .mb : return mb[forLanguage, default: "mb"]
        }
    }
    
    
}
