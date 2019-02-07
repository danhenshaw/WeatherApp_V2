//
//  ViewController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

// The inital view controller is the landing page for the app.
// It checks for User Defaults and requests the current lcoation based on authorisation status.

// INITIAL VIEW CONTROLLER FUNCTIONALITY

// 1. Initialise view with view model and location manager
// 2. Retrieve any locations which may have been previously saved in core data
// 3. Check location authorisation status:
//      3a. Start updating the current location if location authorisation is authorised
//      3b. Segue to next view if location authorisation is restricted or denied
//      3c. Ask user for permission if location authorisation is not determined.
// 4. Update app based on outcome of (3):
//      4a. Segue to main view once we have retrieved the current location
//      4b. Show error alert when we are unable to retrieve the users current location. Ask user if they want to proceed anyway.
//      4c. Segue to main view if user denies location authorisation. Inform user they can change this in phone settings.


import UIKit

enum ScreenOptions {
    case welcome
    case fetchingLocation
    case locationUnavailable
}

protocol InitialViewControllerFlowDelegate: class {
    func showMainViewController(_ senderViewController: InitialViewController, cityDataArray: [CityDataModel])
    func showAlertController(_ senderViewController: InitialViewController, cityDataArray: [CityDataModel])
}

class InitialViewController: UIViewController {

    weak var flowDelegate: InitialViewControllerFlowDelegate?
    fileprivate let viewModel: InitialViewModel
    fileprivate let locationManager: LocationManager!

    
    init(viewModel: InitialViewModel, locationManager: LocationManager) {
        self.viewModel = viewModel
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = InitialView()
    }
    
    var initialView: InitialView { return self.view as! InitialView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getLocationsFromCoreData()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    @objc func appBecameActive() {
        switch locationManager.locationServicesStatus() {
        case .authorizedWhenInUse, .authorizedAlways : startUpdatingLocation()
        case .denied, .restricted : locationPermissionsDenied()
        case .notDetermined : locationManager.locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationPermissionsDenied() {
        initialView.titleLabelTwo.text = "We don't have authorisation to check your current location. \n \n Don't worry, we'll continue anyway."
        _ = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { timer in
            self.flowDelegate?.showMainViewController(self, cityDataArray: self.viewModel.cityData)
        }
    }

    func startUpdatingLocation() {

        locationManager.requestLocation { (currentLocation, error) in
            if let error = error {
                self.flowDelegate?.showAlertController(self, cityDataArray: self.viewModel.cityData)
                print("There was an error fetching the current location: ", error)
            }

            if let currentLocation = currentLocation {
                let cityData = CityDataModel()
                cityData.latitude = currentLocation.latitude
                cityData.longitude = currentLocation.longitude
                cityData.cityName = currentLocation.cityName
                cityData.isCurrentLocation = true
                self.viewModel.cityData.insert(cityData, at: 0)
                self.flowDelegate?.showMainViewController(self, cityDataArray: self.viewModel.cityData)
                print("Success! We have the current location:, ", cityData.latitude, cityData.longitude)
            }
        }
    }
}


