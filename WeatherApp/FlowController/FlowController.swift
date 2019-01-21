//
//  FlowController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class FlowController {
    
    fileprivate let window: UIWindow
    fileprivate weak var navigationController: MainNavigationController?
    
    init(withWindow window: UIWindow) {
        self.window = window
    }
    
    func showMainScren() {
        
        GlobalVariables.sharedInstance.setFontSizeMultipler(screenHeight: Double(window.screen.bounds.height))
        
        let coreDataManager = CoreDataManager()
        let viewModel = InitialViewModel(coreDataManager: coreDataManager)
        let locationManager = LocationManager()
        let viewController = InitialViewController(viewModel: viewModel, locationManager: locationManager)
        
        viewController.flowDelegate = self
        
        let navigationController = MainNavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}




extension FlowController: InitialViewControllerFlowDelegate {

    func showMainViewController(_ senderViewController: InitialViewController, cityDataArray: [CityDataModel]) {
        let model = MainForecastModel(withCities: cityDataArray)
        let viewModel = MainForecastViewModel(withModel: model)
        let mainViewController = MainViewController(withViewModel: viewModel)
        mainViewController.flowDelegate = self
        navigationController!.pushViewController(mainViewController, animated: true)
    }
    
    func showAlertController(_ senderViewController: InitialViewController) {
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: true, completion: nil)
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
    
}



extension FlowController: SettingsViewControllerFlowDelegate {
    
    func showPickerView(_ senderViewController: SettingsViewController, pickerType: PickerType) {
        let model = PickerModel()
        let viewModel = PickerViewModel(withModel: model)
        let pickerViewController = PickerViewController(withViewModel: viewModel, pickerType: pickerType)
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
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}

