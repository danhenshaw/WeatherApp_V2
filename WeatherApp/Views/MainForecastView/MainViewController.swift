//
//  TESTMainViewController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 19/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

// This view controller is responsible for creating the page view controller and the individual pages.
// It also sets the background gradient and handles navigation to settings and location list view controllers.
// The possibility to include advertisement in the app will also be handled from this view controller.

// MAIN VIEW CONTROLLER FUNCTIONALITY

// 1. Initialise view with location manager and set orderedViewControllers to be an array of Forecast View Controllers
// 2. MainForecastModel will retrieve any locations which may have been previously saved in core data and restore settings
// 3. Create each Forecast View Controller based on city data model passed from Initial View
//    View Controllers are contained in a Page View Controller with horizontal swiping.
//    Page Controller is used for visual guide as to which page is currently being displayed.
// 4. Check location authorisation status:
//      4a. Start updating the current location if location authorisation is authorised and update city data array
//      4b. If necessary, remove current location data if location authorisation is restricted or denied
//      4c. Ask user for permission if location authorisation is not determined.
// 5. We contain the navigation items to Location List View Controller and Settings View Controller in the navigation bar
// 6. When Location List button is pressed, we will try and retrieve the forecast for all locations before segueing to the view controller
//    A while loop is used to check when the forecast has been retrieved.
//    If there is an error retrieving any forecast, we will break from the loop and display an alert message
// 7. Delegate notification is received from Forecast View Controller to update the background gradient


import UIKit

protocol MainViewControllerFlowDelegate: class {
    func showSettingsScreen(_ senderViewController: MainViewController)
    func showLocationList(_ senderViewController: MainViewController, locationListDataArray: [LocationListItem]?)
    func showAlertController(_ senderViewController: MainViewController, error: ErrorAlert)
}

class MainViewController: UIPageViewController {
    
    weak var flowDelegate: MainViewControllerFlowDelegate?
    fileprivate let viewModel: MainForecastViewModel
    fileprivate let locationManager: LocationManager
    fileprivate var orderedViewControllers: [ForecastViewController]
    
    init(withViewModel viewModel: MainForecastViewModel, locationManager: LocationManager) {
        self.viewModel = viewModel
        self.locationManager = locationManager
        orderedViewControllers = [ForecastViewController]()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        createViewControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = MainView()
    }
    
    var mainView: MainView { return self.view as! MainView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        mainView.pageViewController.delegate = self
        mainView.pageViewController.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBar(isTranslucent: true, hideBackButton: true)
        addNavigationItems()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If the settings have changed and we had previously downloaded the forecast for the city, we should download it again.
        // We will also update the city name in case of a language change
        
        if GlobalVariables.sharedInstance.settingsHaveChanged == true {
            for index in 0 ..< orderedViewControllers.count {
                if orderedViewControllers[index].viewModel.hasDownloadedForecast() {
                    orderedViewControllers[index].fetchForecast()
                    orderedViewControllers[index].getCityName()
                }
            }
        }
        GlobalVariables.sharedInstance.settingsHaveChanged = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavigationBar(isTranslucent: false, hideBackButton: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func setupNavigationBar(isTranslucent: Bool, hideBackButton: Bool) {
        self.navigationItem.hidesBackButton = hideBackButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
    }
    
    
    func addNavigationItems() {
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftButton.setBackgroundImage(UIImage(named: "list"), for: .normal)
        leftButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        leftButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
     
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightButton.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        rightButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        rightButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    

    @objc func appBecameActive() {
        // When the app become enters the foreground, we want to check if the location authorisation status has changed.
        // It's only necessary to update the view controller at index zero as this will hold the current location data
        orderedViewControllers[0].checkLocationAuthorisationStatus()
    }
    
    @objc func listButtonTapped() {
        
        var locationListItemArray = [LocationListItem]()
        var shouldBreakFromLoop = false
        
        while locationListItemArray.count != orderedViewControllers.count {
            for index in 0 ..< orderedViewControllers.count {
                let forecastPage = orderedViewControllers[index].viewModel
                if forecastPage.shouldUpdateForecast() {
                    orderedViewControllers[index].fetchForecast()
                } else if orderedViewControllers[0].viewModel.getCityData() == nil && locationListItemArray.count == 0 {
                    let locationListData = LocationListItem()
                    locationListData.cityName = "Click here to update settings"
                    locationListData.time = "Current location unavailable"
                    locationListData.isCurrentLocation = false
                    locationListItemArray.append(locationListData)
                } else if forecastPage.hasDownloadedForecast() && locationListItemArray.count == index {
                    locationListItemArray.append(orderedViewControllers[index].viewModel.prepareLocationListData())
                } else if forecastPage.failedToDownloadForecast {
                    // WE WILL BREAK FROM THE LOOP IF WE FAILED TO DOWNLOAD THE FORECAST FOR ONE LOCATION
                    shouldBreakFromLoop = true
                }
            }
            
            if shouldBreakFromLoop { break }
        }
        
        if locationListItemArray.count != 0 {
            flowDelegate?.showLocationList(self, locationListDataArray: locationListItemArray)
        } else {
            flowDelegate?.showAlertController(self, error: .forecastsUnavailable)
        }
    }
    
    
    
    
    @objc func settingsButtonTapped() {
        flowDelegate?.showSettingsScreen(self)
    }
    
    func createViewControllers() {

        let numberOfCities = viewModel.numberOfItemsInSection(0)

        for index in 0 ..< numberOfCities {
            
            let locationManager = LocationManager()
            let cityData : CityDataModel = viewModel.dataForIndexPath(index)
            let model = ForecastDataModel(forCity: cityData)
            let forecastViewModel = ForecastViewModel(withModel: model, pageIndex: index)
            let forecastViewController = ForecastViewController(withViewModel: forecastViewModel, locationManager: locationManager)
            forecastViewController.actionDelegate = self

            orderedViewControllers.append(forecastViewController)
        }
        
        mainView.pageControl.numberOfPages = orderedViewControllers.count
        mainView.pageControl.currentPage = 0
        
        if orderedViewControllers.count != 0 {
            mainView.pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)
        }
    }
    
    
    
}



extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController as! ForecastViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
 
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController as! ForecastViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]

    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.orderedViewControllers.index(of: viewControllers[0] as! ForecastViewController) {
                self.mainView.pageControl.currentPage = viewControllerIndex
            }
        }
    }
 
}



extension MainViewController: ForecastViewControllerActionDelegate {
    
    func updateBackgroundGradient(gradient: [CGColor]) {
        mainView.gradientLayer.colors = gradient
    }
    
    func forecastUnavailable() {
        flowDelegate?.showAlertController(self, error: .forecastUnavailable)
    }
    
    func requestLocationPermissions() {
        flowDelegate?.showAlertController(self, error: .requestLocation)
    }
    
    func locationUnavailable() {
        flowDelegate?.showAlertController(self, error: .locationUnavailable)
    }
    
}




extension MainViewController: LocationListviewControllerActionDelegate {
    
    
    func scrollToPage(atIndex: Int) {
        mainView.pageViewController.setViewControllers([orderedViewControllers[atIndex]], direction: .forward, animated: false, completion: nil)
        mainView.pageControl.currentPage = atIndex
    }

    
    func removePage(atIndex: Int) {
        orderedViewControllers.remove(at: atIndex + 1)
        mainView.pageControl.numberOfPages = orderedViewControllers.count
    }

    
    func addPage(forCity: CityDataModel) {
        
        let currentPageCount = orderedViewControllers.count // Don't need to add one as index will start at 0

        let model = ForecastDataModel(forCity: forCity)
        let forecastViewModel = ForecastViewModel(withModel: model, pageIndex: currentPageCount)
        let forecastViewController = ForecastViewController(withViewModel: forecastViewModel, locationManager: locationManager)
        forecastViewController.actionDelegate = self

        if forCity.isCurrentLocation ?? false {
            orderedViewControllers[0].viewModel.updateCurrentLocation(forCity)
            mainView.pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)
            mainView.pageControl.numberOfPages = orderedViewControllers.count
            mainView.pageControl.currentPage = 0
        } else {
            orderedViewControllers.append(forecastViewController)
            mainView.pageViewController.setViewControllers([orderedViewControllers[orderedViewControllers.count - 1]], direction: .forward, animated: false, completion: nil)
            mainView.pageControl.numberOfPages = orderedViewControllers.count
            mainView.pageControl.currentPage = orderedViewControllers.count - 1
        }
    }
}







