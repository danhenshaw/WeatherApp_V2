//
//  PickerModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

enum PickerType {
    case units
    case language
    case forecast
}

struct PickerItem {
    let shortName: String
    let longName: String
}


struct PickerModel {
    
    let units = [PickerItem(shortName: "us", longName: "°F, mph"),
                 PickerItem(shortName: "uk2", longName: "°C, mph"),
                 PickerItem(shortName: "ca", longName: "°C, km/h"),
                 PickerItem(shortName: "si", longName: "°C, m/s")]
    
    
    let language = [
//                    PickerItem(shortName: "ar", longName: "Arabic"),
//                    PickerItem(shortName: "az", longName: "Azerbaijani"),
//                    PickerItem(shortName: "be", longName: "Belarusian"),
//                    PickerItem(shortName: "bg", longName: "Bulgarian"),
//                    PickerItem(shortName: "bs", longName: "Bosnian"),
//                    PickerItem(shortName: "ca", longName: "Catalan"),
//                    PickerItem(shortName: "cs", longName: "Czech"),
//                    PickerItem(shortName: "da", longName: "Danish"),
//                    PickerItem(shortName: "de", longName: "Deutsch"),
//                    PickerItem(shortName: "el", longName: "Greek"),
                    PickerItem(shortName: "en", longName: "English"),
                    PickerItem(shortName: "es", longName: "Español"),
//                    PickerItem(shortName: "et", longName: "Estonian"),
//                    PickerItem(shortName: "fi", longName: "Finnish"),
                    PickerItem(shortName: "fr", longName: "Fançais"),
//                    PickerItem(shortName: "he", longName: "Hebrew"),
//                    PickerItem(shortName: "hr", longName: "Croatian"),
//                    PickerItem(shortName: "hu", longName: "Hungarian"),
//                    PickerItem(shortName: "id", longName: "Indonesian"),
//                    PickerItem(shortName: "is", longName: "Icelandic"),
                    PickerItem(shortName: "it", longName: "Italiano"),
                    PickerItem(shortName: "ja", longName: "日本人"),
//                    PickerItem(shortName: "ka", longName: "Georgian"),
//                    PickerItem(shortName: "ko", longName: "Korean"),
//                    PickerItem(shortName: "kw", longName: "Cornish"),
//                    PickerItem(shortName: "lv", longName: "Latvian"),
//                    PickerItem(shortName: "nb", longName: "Norwegian"),
//                    PickerItem(shortName: "nl", longName: "Nederlands"),
//                    PickerItem(shortName: "pl", longName: "Polish"),
//                    PickerItem(shortName: "pt", longName: "Portuguese"),
//                    PickerItem(shortName: "ro", longName: "Romanian"),
//                    PickerItem(shortName: "ru", longName: "Russian"),
//                    PickerItem(shortName: "sk", longName: "Slovak"),
//                    PickerItem(shortName: "sl", longName: "Slovenian"),
//                    PickerItem(shortName: "sr", longName: "Serbian"),
//                    PickerItem(shortName: "sv", longName: "Swedish"),
//                    PickerItem(shortName: "tet", longName: "Tetum"),
                    PickerItem(shortName: "tr", longName: "Türk"),
//                    PickerItem(shortName: "uk", longName: "Ukrainian"),
                    PickerItem(shortName: "x-pig-latin", longName: "Igpay Atinlay"),
                    PickerItem(shortName: "zh", longName: "汉字简化方案"),
                    PickerItem(shortName: "zh-tw", longName: "漢字傳統方案")]
    
    let forecast = [PickerItem(shortName: "us", longName: "US"),
                    PickerItem(shortName: "uk2", longName: "UK2"),
                    PickerItem(shortName: "ca", longName: "CA"),
                    PickerItem(shortName: "si", longName: "SI")]
    

        
}
