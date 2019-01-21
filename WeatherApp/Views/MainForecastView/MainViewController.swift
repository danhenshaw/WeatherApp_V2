//
//  TESTMainViewController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 19/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

protocol MainViewControllerFlowDelegate: class {
    func showSettingsScreen(_ senderViewController: MainViewController)
    func showLocationList(_ senderViewController: MainViewController, locationListDataArray: [LocationListItem]?)
}

class MainViewController: UIPageViewController {
    
    weak var flowDelegate: MainViewControllerFlowDelegate?
    fileprivate let viewModel: MainForecastViewModel
    var orderedViewControllers: [ForecastViewController]
    
    init(withViewModel viewModel: MainForecastViewModel) {
        self.viewModel = viewModel
        orderedViewControllers = [ForecastViewController]()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
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
        mainView.pageViewController.delegate = self
        mainView.pageViewController.dataSource = self
        createViewControllers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBar(isTranslucent: true, hideBackButton: true)
        addNavigationItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkToSeeIfLocationServicesChanged()
        if GlobalVariables.sharedInstance.settingsHaveChanged == true {
            for index in 0 ..< orderedViewControllers.count {
                if orderedViewControllers[index].viewModel.hasDownloadedForecast() {
                    orderedViewControllers[index].fetchForecast()
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
    
    
    
    
    @objc func listButtonTapped() {
        var locationListItemArray = [LocationListItem]()
        var shouldBreakFromLoop = false
        
        while locationListItemArray.count != orderedViewControllers.count {
            for index in 0 ..< orderedViewControllers.count {
                let forecastPage = orderedViewControllers[index].viewModel
                if forecastPage.shouldUpdateForecast() {
                    orderedViewControllers[index].fetchForecast()
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
        }
    }
    
    
    
    
    @objc func settingsButtonTapped() {
        flowDelegate?.showSettingsScreen(self)
    }
    
    
    
    func checkToSeeIfLocationServicesChanged() {
            switch LocationManager().locationServicesStatus() {
            case .denied, .restricted, .notDetermined :
                if orderedViewControllers.count == 0 {
                    flowDelegate?.showLocationList(self, locationListDataArray: nil)
                } else if (orderedViewControllers[0].viewModel.prepareLocationListData().isCurrentLocation ?? false) && orderedViewControllers.count == 1 {
                    orderedViewControllers.remove(at: 0)
                    flowDelegate?.showLocationList(self, locationListDataArray: nil)
                } else if (orderedViewControllers[0].viewModel.prepareLocationListData().isCurrentLocation ?? false) {
                    orderedViewControllers.remove(at: 0)
                    mainView.pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)
                    mainView.pageControl.numberOfPages = orderedViewControllers.count
                }
                
                
            default :
                if !(orderedViewControllers[0].viewModel.prepareLocationListData().isCurrentLocation ?? false) {
                    LocationManager().requestLocation { (currentLocation, error) in
                        
                        if let error = error {
                            print("There was an error retrieiving your location: ", error)
                        }
                        
                        if let currentLocation = currentLocation {
                            print("SUCCESS! We have your current location as ", currentLocation.cityName)
                            let cityData = CityDataModel()
                            cityData.latitude = currentLocation.latitude
                            cityData.longitude = currentLocation.longitude
                            cityData.cityName = currentLocation.cityName
                            cityData.isCurrentLocation = true
                            
                            let model = ForecastDataModel(forCity: cityData)
                            let forecastViewModel = ForecastViewModel(withModel: model)
                            let forecastViewController = ForecastViewController(withViewModel: forecastViewModel)
                            forecastViewController.actionDelegate = self
                            self.orderedViewControllers.insert(forecastViewController, at: 0)
                            self.mainView.pageViewController.setViewControllers([self.orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)
                            self.mainView.pageControl.numberOfPages = self.orderedViewControllers.count
                        }
                    }
                }
            }
    }
    
    
    
    func createViewControllers() {

        let numberOfCities = viewModel.numberOfItemsInSection(0)

        for index in 0 ..< numberOfCities {
            let cityData : CityDataModel = viewModel.dataForIndexPath(index)
            let model = ForecastDataModel(forCity: cityData)
            let forecastViewModel = ForecastViewModel(withModel: model)
            let forecastViewController = ForecastViewController(withViewModel: forecastViewModel)
            forecastViewController.actionDelegate = self
            orderedViewControllers.append(forecastViewController)
        }
        if orderedViewControllers.count != 0 {
            mainView.pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)
        }
        
        mainView.pageControl.numberOfPages = orderedViewControllers.count
        mainView.pageControl.currentPage = 0
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
        
        let model = ForecastDataModel(forCity: forCity)
        let forecastViewModel = ForecastViewModel(withModel: model)
        let forecastViewController = ForecastViewController(withViewModel: forecastViewModel)
        forecastViewController.actionDelegate = self
        
        if forCity.isCurrentLocation ?? false {
            orderedViewControllers.insert(forecastViewController, at: 0)
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







