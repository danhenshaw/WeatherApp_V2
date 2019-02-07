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
    func showForecastDataTableView()
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
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SettingsCell.self, forCellReuseIdentifier: Constants.settingsCellReuseIdentifier)
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
        
        if settingsItem.value == "language" {
            let savedLanguage = GlobalVariables.sharedInstance.language
            cell.valueLabel.text = Translator().getString(forLanguage: savedLanguage, string: "language")
        } else if settingsItem.value == "units" {
            let savedUnits = GlobalVariables.sharedInstance.units
            cell.valueLabel.text = Translator().getString(forLanguage: savedUnits, string: "units")
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = viewModel.settingItemForIndexPath(indexPath).action
        handleCellAction(action, value: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    
    fileprivate func handleCellAction(_ action: SettingItemAction?, value: Bool?) {
        guard let action = action else { return }
        
        switch action {
        case .changeUnits : flowDelegate?.showPickerView(self, pickerType: .units)
        case .changeLanguage : flowDelegate?.showPickerView(self, pickerType: .language)
        case .changeForecastData : flowDelegate?.showForecastDataTableView()
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
        let firstActivityItem = "WeatherAPP"
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

