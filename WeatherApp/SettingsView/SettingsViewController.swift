//
//  SettingsViewController2.swift
//  WeatherApp_V5
//
//  Created by Daniel Henshaw on 29/11/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

enum SettingsViewControllerAction {
    case showPickerViewUnits
    case showPickerViewLanguage
    case showPickerViewForecast
}


protocol SettingsViewControllerFlowDelegate: class {
    func showPickerView(_ senderViewController: SettingsViewController, pickerType: PickerType)
}


class SettingsViewController : UITableViewController {

    weak var flowDelegate: SettingsViewControllerFlowDelegate?
    fileprivate let viewModel: SettingsViewModel
    
    
    
    struct Constants {
        static let settingsCellReuseIdentifier = "SettingsCellReuseIdentifier"
        static let settingsHeaderViewReuseIdentifier = "SettingsHeaderViewReuseIdentifier"
    }
    
    init(withViewModel viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: Constants.settingsCellReuseIdentifier)
        tableView.register(SettingsHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.settingsHeaderViewReuseIdentifier)
        title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsItem = viewModel.settingItemForIndexPath(indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.settingsCellReuseIdentifier, for: indexPath) as! SettingsCell
        cell.bindWithSettingItem(settingsItem)
        cell.configureCellForSettingItem(settingsItem)
        cell.accessoryType = .disclosureIndicator
        if settingsItem.value == "language" {
            cell.valueLabel.text = GlobalVariables.sharedInstance.languageLong
        } else if settingsItem.value == "units" {
            cell.valueLabel.text = GlobalVariables.sharedInstance.unitsLong
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let action = viewModel.settingItemForIndexPath(indexPath).action
        handleCellAction(action, value: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }


    fileprivate func handleCellAction(_ action: SettingItemAction?, value: Bool?) {
        guard let action = action else { return }
        
        switch action {
        case .changeUnits : flowDelegate?.showPickerView(self, pickerType: .units)
        case .changeLanguage : flowDelegate?.showPickerView(self, pickerType: .language)
        case .openPhoneSettings : UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .rateApp : UIApplication.shared.open(URL(string: "https://www.apple.com/lae/ios/app-store/")! as URL, options: [:], completionHandler: nil)
            
        case .feedbackAndSupport : openEmail()
        case .share : share()
        case .privacyPolicy : print("OPEN PRIVACY POLICY")
        case .linkToWebsite : UIApplication.shared.open(URL(string: "https://www.google.com")! as URL, options: [:], completionHandler: nil)
        case .linkToInstagram : UIApplication.shared.open(URL(string: "https://www.instagram.com")! as URL, options: [:], completionHandler: nil)
        case .linkToFacebook : UIApplication.shared.open(URL(string: "https://www.facebook.com")! as URL, options: [:], completionHandler: nil)
        case .linkToTwitter : UIApplication.shared.open(URL(string: "https://www.twitter.com")! as URL, options: [:], completionHandler: nil)
            
        }
    }
    
    func openEmail() {
        let subject = "weatherAPP - User Feedback"
        let body = ""
        let coded = "mailto:feedback@weatherapp.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        UIApplication.shared.open(NSURL(string: coded!)! as URL, options: [:], completionHandler: nil)
    }
    
    func share() {
        let firstActivityItem = "Text you want"
        let secondActivityItem = NSURL(string: "https://www.google.com")!

        let activityViewController = UIActivityViewController(activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]

        self.present(activityViewController, animated: true, completion: nil)
    }
    



}

