//
//  FlowController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

enum ErrorAlert { case locationUnavailable, requestLocation, forecastUnavailable, forecastsUnavailable }

// The Flow Controller is responsible for presenting all new views and is accomplished by using the delegate pattern

class FlowController {
    
    fileprivate let window: UIWindow
    fileprivate weak var navigationController: MainNavigationController?
    
    init(withWindow window: UIWindow) {
        self.window = window
    }
    
    func showMainScren() {

        GlobalVariables.sharedInstance.setFontSizeMultipler(screenHeight: Double(window.screen.bounds.height))
        
        let coreDataManager = CoreDataManager()
        let locationManager = LocationManager()

        let model = MainForecastModel(coreDataManager: coreDataManager)
        let viewModel = MainForecastViewModel(withModel: model)
        let mainViewController = MainViewController(withViewModel: viewModel, locationManager: locationManager)
        mainViewController.flowDelegate = self
        
        let navigationController = MainNavigationController(rootViewController: mainViewController)
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}



extension FlowController: MainViewControllerFlowDelegate {    
    
    func showSettingsScreen(_ senderViewController: MainViewController) {
        let model = SettingsModel()
        let viewModel = SettingsViewModel(withModel: model)
        let settingsViewController = SettingsViewController(withViewModel: viewModel)
        settingsViewController.flowDelegate = self
        navigationController!.pushViewController(settingsViewController, animated: true)
    }
    
    func showLocationList(_ senderViewController: MainViewController, locationListDataArray: [LocationListItem]?) {
        let model = LocationListModel(withLocations: locationListDataArray)
        let viewModel = LocationListViewModel(withModel: model)
        let locationListViewController = LocationListViewController(withViewModel: viewModel)
        locationListViewController.flowDelegate = self
        locationListViewController.actionDelegate = senderViewController
        navigationController!.pushViewController(locationListViewController, animated: true)
    }

    func showAlertController(_ senderViewController: MainViewController, error: ErrorAlert) {
        
        var title = ""
        var message = ""
        var showOKAction = false
        
        switch error {
        case .locationUnavailable :
            title = NSLocalizedString("Oops...something went wrong.", comment: "")
            message = NSLocalizedString("We were unable to retrieve your location. Please try again later.", comment: "")
            showOKAction = false
        case .requestLocation :
            title = NSLocalizedString("Location Permission Required.", comment: "")
            message = NSLocalizedString("Please enable location permissions in settings.", comment: "")
            showOKAction = true
        case .forecastUnavailable :
            title = NSLocalizedString("Oops...something went wrong.", comment: "")
            message = NSLocalizedString("We were unable to retrieve the forecast. Please try again later.", comment: "")
            showOKAction = false
        case .forecastsUnavailable :
            title = NSLocalizedString("Oops...something went wrong.", comment: "")
            message = NSLocalizedString("We were unable to retrieve all forecasts. Please try again later.", comment: "")
            showOKAction = false
        }
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: UIAlertAction.Style.cancel)
        
        alertController.addAction(cancelAction)
        
        if showOKAction {
            
            let okAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""),
                                         style: .default,
                                         handler: {(cAlertAction) in
                                            
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            alertController.addAction(okAction)
        }
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    
}


extension FlowController: SettingsViewControllerFlowDelegate {
    
    
    func showForecastDataTableView() {
        let model = CustomiseableForecastDataModel()
        let viewModel = CustomiseableForecastDataViewModel(withModel: model)
        let customiseableForecastDataViewController = CustomiseableForecastDataViewController(withViewModel: viewModel)
        customiseableForecastDataViewController.flowDelegate = self
        navigationController!.pushViewController(customiseableForecastDataViewController, animated: true)
    }
    
    
    func showPickerView(_ senderViewController: SettingsViewController, pickerType: PickerType) {
        let model = PickerModel()
        let viewModel = PickerViewModel(withModel: model)
        let pickerViewController = PickerViewController(withViewModel: viewModel, pickerType: pickerType, forecastSection: nil, slot: nil)
        navigationController!.pushViewController(pickerViewController, animated: true)
    }
}





extension FlowController: LocationListViewControllerFlowDelegate {

    func showAddLocationViewController(_ senderViewController: LocationListViewController) {
        let addLocationViewController = AddLocationViewController()
        addLocationViewController.actionDelegate = senderViewController
        navigationController?.pushViewController(addLocationViewController, animated: true)
    }
    
    func showAlertController(_ senderViewController: LocationListViewController) {
        let alertController = UIAlertController(title: NSLocalizedString("Location Permission Required", comment: ""),
                                                message: NSLocalizedString("Please enable location permissions in settings.", comment: ""),
                                                preferredStyle: UIAlertController.Style.alert)
 
        let okAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""),
                                     style: .default,
                                     handler: {(cAlertAction) in
                                        
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: UIAlertAction.Style.cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}


extension FlowController: CustomiseableForecastDataViewControllerFlowDelegate {
    func showPickerView(_ senderViewController: CustomiseableForecastDataViewController, pickerType: PickerType, forecastSection: ForecastSection, slot: Int) {
        let model = PickerModel()
        let viewModel = PickerViewModel(withModel: model)
        let pickerViewController = PickerViewController(withViewModel: viewModel, pickerType: pickerType, forecastSection: forecastSection, slot: slot)
        navigationController!.pushViewController(pickerViewController, animated: true)
    }
}

