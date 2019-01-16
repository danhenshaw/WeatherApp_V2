//
//  Date.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 2/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

enum DateFormat {
    case medium, mediumWithTime, day, timeShort, timeLong
}

class FormatDate {
    
    func date(unixtimeInterval: Int, timeZone: String, format: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: Double(unixtimeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        switch format {
        case .medium :
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
        case .mediumWithTime :
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
        case .day :
            dateFormatter.dateFormat = "E"
        case .timeShort :
            dateFormatter.dateFormat = "HH"
        case .timeLong :
            dateFormatter.dateFormat = "HH:mm"
        }
        
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
}
