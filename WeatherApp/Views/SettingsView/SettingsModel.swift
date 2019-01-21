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
    let subTitle: String
    let hideSubTitleLabel: Bool
    let value: String?
    let icon: String
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
                SettingItem(title: "Settings", subTitle: "Open in Settings app", hideSubTitleLabel: false, value: nil, icon: "⚙︎", type: .externalLink, action: .openPhoneSettings),
            ]
        ),
        
        
        SettingsGroup(
            name: "Options",
            items: [
                SettingItem(title: "Language", subTitle: "", hideSubTitleLabel: true, value: "language", icon: "L", type: .internalSegue, action: .changeLanguage),
                SettingItem(title: "Units", subTitle: "", hideSubTitleLabel: true, value: "units", icon: "U", type: .internalSegue, action: .changeUnits)
            ]
        ),
        
        
        
        SettingsGroup(
            name: "General",
            items: [
                SettingItem(title: "Share", subTitle: "", hideSubTitleLabel: true, value: nil, icon: "S", type: .internalSegue, action: .share),
                SettingItem(title: "Feedback and Support", subTitle: "", hideSubTitleLabel: true, value: nil, icon: "S", type: .externalLink, action: .feedbackAndSupport),
                SettingItem(title: "Rate App", subTitle: "Review on the App Store", hideSubTitleLabel: false, value: nil, icon: "R", type: .externalLink, action: .rateApp)
            ]
        ),
        
        
        SettingsGroup(
            name: "About",
            items: [
                SettingItem(title: "Website", subTitle: "", hideSubTitleLabel: true, value: nil, icon: "W", type: .externalLink, action: .linkToWebsite),
                SettingItem(title: "Facebook", subTitle: "", hideSubTitleLabel: true, value: nil, icon: "F", type: .externalLink, action: .linkToFacebook),
                SettingItem(title: "Instagram", subTitle: "", hideSubTitleLabel: true, value: nil, icon: "I", type: .externalLink, action: .linkToInstagram),
                SettingItem(title: "Twitter", subTitle: "", hideSubTitleLabel: true, value: nil, icon: "T", type: .externalLink, action: .linkToTwitter)
            ]
        )
        
        
    ]
}
