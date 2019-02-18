//
//  SettingsViewController2.swift
//  WeatherApp_V5
//
//  Created by Daniel Henshaw on 29/11/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationListViewControllerFlowDelegate: class {
    func showAddLocationViewController(_ senderViewController: LocationListViewController)
    func showAlertController(_ senderViewController: LocationListViewController)
}

protocol LocationListviewControllerActionDelegate: class {
    func scrollToPage(atIndex: Int)
    func removePage(atIndex: Int)
    func addPage(forCity: CityDataModel)
}


class LocationListViewController : UIViewController { 

    weak var flowDelegate: LocationListViewControllerFlowDelegate?
    weak var actionDelegate: LocationListviewControllerActionDelegate?
    fileprivate let viewModel: LocationListViewModel
    
    struct Constants {
        static let locationListCellReuseIdentifier = "LocationListCellReuseIdentifier"
        static let headerViewReuseIdentifier = "HeaderViewReuseIdentifier"
        static let footerViewReuseIdentifier = "FooterViewReuseIdentifier"
    }
    
    init(withViewModel viewModel: LocationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func loadView() { view = LocationListView() }
    
    var locationListView: LocationListView { return self.view as! LocationListView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        locationListView.tableView.dataSource = self
        locationListView.tableView.delegate = self
        locationListView.backgroundGradient = [UIColor.orange.cgColor, UIColor.purple.cgColor]
        locationListView.tableView.register(LocationListCell.self, forCellReuseIdentifier: Constants.locationListCellReuseIdentifier)
        locationListView.tableView.register(LocationListHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerViewReuseIdentifier)
        locationListView.tableView.register(LocationListFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.footerViewReuseIdentifier)
        title = "Locations"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(isTranslucent: true, hideBackButton: true)
        addNavigationItems()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    @objc func appBecameActive() {
        switch LocationManager().locationServicesStatus() {
        case .denied, .restricted, .notDetermined :
            if viewModel.locationItemForIndexPath(0)?.isCurrentLocation ?? false {
                viewModel.removeItem(0)
                actionDelegate?.removePage(atIndex: 0)
                locationListView.tableView.reloadData()
            }
        default :
            if !(viewModel.locationItemForIndexPath(0)?.isCurrentLocation ?? false) {
                LocationManager().requestLocation { (currentLocation, error) in
                    if let error = error {
                        print("There was an error retrieiving your location: ", error)
                    }
                    if let currentLocation = currentLocation {
                        print("Success! We have the current location.")
                        let cityData = CityDataModel()
                        cityData.latitude = currentLocation.latitude
                        cityData.longitude = currentLocation.longitude
                        cityData.cityName = currentLocation.cityName
                        cityData.isCurrentLocation = true
                        self.actionDelegate?.addPage(forCity: cityData)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    
    func setupNavigationBar(isTranslucent: Bool, hideBackButton: Bool) {
        self.navigationItem.hidesBackButton = hideBackButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    func addNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    
    @objc func addButtonTapped() {
        flowDelegate?.showAddLocationViewController(self)
    }
    
    
    @objc func headerTapped(_ sender: UIButton) {

        if viewModel.isUsingCurrentLocation() {
            self.navigationController?.popViewController(animated: true)
            actionDelegate?.scrollToPage(atIndex: 0)
        } else  {
            flowDelegate?.showAlertController(self)
        }
    }
    
}
    
    
extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerViewReuseIdentifier) as! LocationListHeaderView
        view.button.addTarget(self, action: #selector(headerTapped(_:)), for: .touchUpInside)
        let locationListItem = viewModel.locationItemForIndexPath(0)
        view.bindWithLocationListItem(locationListItem!)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerViewReuseIdentifier) as! LocationListFooterView
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.view.frame.height * 0.075
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.backgroundView?.backgroundColor = UIColor.clear
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let locationListItem = viewModel.locationItemForIndexPath(indexPath.row + 1)
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationListCellReuseIdentifier, for: indexPath) as! LocationListCell
        cell.bindWithLocationListItem(locationListItem!)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
        actionDelegate?.scrollToPage(atIndex: indexPath.row + 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataStack.shared.delete(index: indexPath.row)
            self.viewModel.removeItem(indexPath.row)
            self.actionDelegate?.removePage(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }

}

extension LocationListViewController: AddLocationViewControllerActionDelegate {

    func userAdded(newCity: CityDataModel) {
        actionDelegate?.addPage(forCity: newCity)
        self.navigationController?.popViewController(animated: true)
    }
}

extension LocationListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for cell in locationListView.tableView.visibleCells {
            
            let hiddenFrameHeight = locationListView.tableView.contentOffset.y + view.frame.size.height * 0.25 - cell.frame.origin.y
            
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                
                if let cell = cell as? LocationListCell {
                    cell.maskCell(fromTop: hiddenFrameHeight)
                }
            }
        }
    }
}
