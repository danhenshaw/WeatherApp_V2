//
//  SettingsModel.swift
//  WeatherApp_V5
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//



import Foundation
import UIKit

struct SettingsGroup {
    let name: String
    let items: [SettingItem]
}

struct SettingItem {
    let title: String
    let subTitle: String?
    let value: String?
    let type: SettingItemType
    let action: SettingItemAction
}

enum SettingItemType {
    case externalLink
    case internalSegue
}

enum SettingItemAction {
    case changeUnits
    case changeLanguage
    case changeForecastData
    case openPhoneSettings
    case rateApp
    case feedbackAndSupport
    case share
    case privacyPolicy
    case linkToWebsite
    case linkToInstagram
    case linkToFacebook
    case linkToTwitter
}

struct SettingsModel {
    
    let settings = [
        
        SettingsGroup(
            name: "Privacy",
            items: [
                SettingItem(title: "Settings", subTitle: "Open in Settings app", value: nil, type: .externalLink, action: .openPhoneSettings),
            ]
        ),
        
        
        SettingsGroup(
            name: "Options",
            items: [
                SettingItem(title: "Language", subTitle: nil, value: "language", type: .internalSegue, action: .changeLanguage),
                SettingItem(title: "Units", subTitle: nil, value: "units", type: .internalSegue, action: .changeUnits),
                SettingItem(title: "Customise Data", subTitle: "Choose what you want to see", value: nil, type: .internalSegue, action: .changeForecastData)
            ]
        ),
        
        
        
        SettingsGroup(
            name: "General",
            items: [
                SettingItem(title: "Share", subTitle: nil, value: nil, type: .internalSegue, action: .share),
                SettingItem(title: "Feedback and Support", subTitle: nil, value: nil, type: .externalLink, action: .feedbackAndSupport),
                SettingItem(title: "Rate App", subTitle: "Review on the App Store", value: nil, type: .externalLink, action: .rateApp)
            ]
        ),
        
        
        SettingsGroup(
            name: "About",
            items: [
                SettingItem(title: "Website", subTitle: nil, value: nil, type: .externalLink, action: .linkToWebsite),
                SettingItem(title: "Facebook", subTitle: nil, value: nil, type: .externalLink, action: .linkToFacebook),
                SettingItem(title: "Instagram", subTitle: nil, value: nil, type: .externalLink, action: .linkToInstagram),
                SettingItem(title: "Twitter", subTitle: nil, value: nil, type: .externalLink, action: .linkToTwitter)
            ]
        )
        
        
    ]
}
