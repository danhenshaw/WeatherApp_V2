//
//  ViewController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

enum ScreenOptions {
    case welcome
    case fetchingLocation
    case locationUnavailable
}

protocol InitialViewControllerFlowDelegate: class {
    func showMainViewController(_ senderViewController: InitialViewController, cityDataArray: [CityDataModel])
    func showAlertController(_ senderViewController: InitialViewController)
}

class InitialViewController: UIViewController {

    weak var flowDelegate: InitialViewControllerFlowDelegate?
    fileprivate let viewModel: InitialViewModel
    
    fileprivate let locationManager: LocationManager! 
    fileprivate let coreDataManager: CoreDataManager!

    fileprivate var haveRequestedLocationServices = false
    fileprivate var haveSeguedToMainViewController = false
    
    init(viewModel: InitialViewModel) {
        self.viewModel = viewModel
        locationManager = LocationManager()
        coreDataManager = CoreDataManager()
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self as? InitialViewModelDelegate
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
        initialView.locationServicesButton.addTarget(self, action: #selector(InitialViewController.locationServicesButtonTapped(_:)), for: .touchUpInside)
        initialView.skipButton.addTarget(self, action: #selector(InitialViewController.skipButtonTapped(_:)), for: .touchUpInside)
        viewModel.getLocationsFromCoreData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorisationStatus()
    }
    
    
    @objc func appBecameActive() {
        switch locationManager.locationServicesStatus() {
        case .authorizedWhenInUse, .authorizedAlways :
            startUpdatingLocation()
            updateScreen(type: .fetchingLocation)
        default :
            updateScreen(type: .locationUnavailable)
        }
    }
    

    func checkLocationAuthorisationStatus() {
        switch locationManager.locationServicesStatus() {
        case .authorizedAlways, .authorizedWhenInUse :
            updateScreen(type: .fetchingLocation)
            startUpdatingLocation()
        case .notDetermined :
            updateScreen(type: .welcome)
        case .restricted, .denied :
            print("Location services restricted or denied - navigate to main view controller without retrieveing the current location")
            self.flowDelegate?.showMainViewController(self, cityDataArray: self.viewModel.cityData)
        }
    }
    
    
    
    func startUpdatingLocation() {
        
        locationManager.requestLocation { (currentLocation, error) in
            if let error = error {
                self.updateScreen(type: .locationUnavailable)
                print("There was an error fetching the current location: ", error)
            }

            if let currentLocation = currentLocation {
                print("SUCCESS! We have your current location as ", currentLocation.cityName)
                let cityData = CityDataModel()
                cityData.latitude = currentLocation.latitude
                cityData.longitude = currentLocation.longitude
                cityData.cityName = currentLocation.cityName
                cityData.isCurrentLocation = true
                self.viewModel.cityData.insert(cityData, at: 0)
                self.flowDelegate?.showMainViewController(self, cityDataArray: self.viewModel.cityData)
            }
        }
    }


    @objc func locationServicesButtonTapped(_ sender: UIButton) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        switch locationManager.locationServicesStatus() {
        case .notDetermined : locationManager.locationManager.requestWhenInUseAuthorization()
        default : flowDelegate?.showAlertController(self)
        }
    }
    
    
    @objc func skipButtonTapped(_ sender: UIButton) {
        flowDelegate?.showMainViewController(self, cityDataArray: viewModel.cityData)
    }
    
    
    func updateScreen(type: ScreenOptions) {
        
        initialView.locationServicesButton.isEnabled = false
        initialView.skipButton.isEnabled = false
        
        switch type {
        case .fetchingLocation :
            initialView.titleLabelTwo.text = "Hold tight!"
            initialView.titleLabelTwo.text = "...we're updating your location..."
        case .locationUnavailable :
            initialView.titleLabelTwo.text = "Oops! :("
            initialView.titleLabelTwo.text = "...we couldn't retrieve your location"
            initialView.locationServicesButton.setTitle("", for: .normal)
            initialView.skipButton.setTitle("Continue anyway", for: .normal)
            initialView.skipButton.isEnabled = true
        case .welcome :
            initialView.locationServicesButton.isEnabled = true
            initialView.skipButton.isEnabled = true
        }
    }
    
    
    
}


