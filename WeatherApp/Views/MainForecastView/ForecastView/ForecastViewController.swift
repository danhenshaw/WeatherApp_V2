//
//  ForecastViewController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 20/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

protocol ForecastViewControllerActionDelegate: class {
    func updateBackgroundGradient(gradient: [CGColor])
}

class ForecastViewController : UITableViewController {
    
    let viewModel: ForecastViewModel
    internal let refresher: UIRefreshControl!
    
    weak var actionDelegate: ForecastViewControllerActionDelegate?
    
    var forecastOverviewSection : ForecastSection = .currently
    var forecastOverviewIndex = 0
    
    var forecastChartSection : ForecastSection = .daily
    
    struct Constants {
        static let titleCellReuseIdentifier = "TitleCellReuseIdentifier"
        static let forecastOverviewCellReuseIdentifier = "ForecastOverviewCellReuseIdentifier"
        static let minutelyForecastCellReuseIdentifier = "MinutelyForecastCellReuseIdentifier"
        static let hourlyOrDailyForecastCellReuseIdentifier = "HourlyOrDailyForecastCellReuseIdentifier"
        static let buttonCellReuseIdentifier = "ButtonCellReuseIdentifier"
    }
    
    init(withViewModel viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        refresher = UIRefreshControl()
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(pulledToRefresh(_:)), for: .valueChanged)
        tableView.backgroundColor = .clear
        tableView.register(TitleCell.self, forCellReuseIdentifier: Constants.titleCellReuseIdentifier)
        tableView.register(ForecastOverviewCell.self, forCellReuseIdentifier: Constants.forecastOverviewCellReuseIdentifier)
        tableView.register(MinutelyForecastCell.self, forCellReuseIdentifier: Constants.minutelyForecastCellReuseIdentifier)
        tableView.register(HourlyOrDailyForecastCell.self, forCellReuseIdentifier: Constants.hourlyOrDailyForecastCellReuseIdentifier)
        getCityName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        if viewModel.shouldUpdateForecast() { fetchForecast() }
    }
    
    
    @objc private func pulledToRefresh(_ sender: Any) {
        if viewModel.shouldUpdateForecast() {
            fetchForecast()
        } else if refresher.isRefreshing {
            endRefreshing()
        }
    }
    
    
    func getCityName() {
        LocationManager().requestCityName(latitude: viewModel.getCityData().latitude, longitude: viewModel.getCityData().longitude) { (cityName, error) in
            if let error = error { print("Error getting city name:", error) }
            if let cityName = cityName { self.viewModel.updateCityName(cityName: cityName) }
            self.tableView.reloadData()
        }
    }
    
    
    func fetchForecast() {
        startRefreshing()
        self.viewModel.isDownloadingForecast = true
        let latitude = viewModel.getCityData().latitude
        let longitude = viewModel.getCityData().longitude
        
        DarkSkyAPI().fetchWeather(latitude: latitude, longitude: longitude) { (retrievedForecast, error) in
            
            if let error = error {
                print("There was an error retrieving the forecast:", error)
                self.viewModel.isDownloadingForecast = false
                self.viewModel.failedToDownloadForecast = true
                self.endRefreshing()
            }
            
            if retrievedForecast != nil {
                self.viewModel.updateForecast(with: retrievedForecast!)
                self.viewModel.isDownloadingForecast = false
                self.viewModel.failedToDownloadForecast = false
                self.actionDelegate?.updateBackgroundGradient(gradient: self.viewModel.generateBackgroundGradient(forecastSection: self.forecastOverviewSection, index: self.forecastOverviewIndex))
                self.endRefreshing()
            }
        }
    }
    
    func startRefreshing() {
        DispatchQueue.main.async() {
            if !self.refresher.isRefreshing {
                self.refresher.beginRefreshing()
            }
        }
    }
    
    
    func endRefreshing() {
        DispatchQueue.main.async() {
            if self.refresher.isRefreshing {
                self.refresher.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var  cell: UITableViewCell!
        
        switch indexPath.row {
        case 0 :
            
            let titleCell = tableView.dequeueReusableCell(withIdentifier: Constants.titleCellReuseIdentifier, for: indexPath) as! TitleCell
            let cellData = viewModel.prepareTitleCellData(forecastSection: forecastOverviewSection, index: forecastOverviewIndex)
            titleCell.bindWith(cellData)
            cell = titleCell
            
        case 1 :
            
            let forecastOverviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.forecastOverviewCellReuseIdentifier, for: indexPath) as! ForecastOverviewCell
            let cellData = viewModel.prepareForecastOverviewCellData(forecastSection: forecastOverviewSection, index: forecastOverviewIndex)
            forecastOverviewCell.bindWith(cellData)
            forecastOverviewCell.configureCell(forecastOverviewSection)
            cell = forecastOverviewCell
            
        case 2 :
            
            let minutelyForecastCell = tableView.dequeueReusableCell(withIdentifier: Constants.minutelyForecastCellReuseIdentifier, for: indexPath) as! MinutelyForecastCell
            let cellData = viewModel.prepareMinutelyForecastCellData(forecastSection: forecastOverviewSection, index: forecastOverviewIndex)
            minutelyForecastCell.bindWith(cellData)
            cell = minutelyForecastCell
            
        case 3 :
            
            let hourlyOrDailyForecastCell = tableView.dequeueReusableCell(withIdentifier: Constants.hourlyOrDailyForecastCellReuseIdentifier, for: indexPath) as! HourlyOrDailyForecastCell
            
            if forecastChartSection == .daily {
                 hourlyOrDailyForecastCell.sectionData = viewModel.prepareDailyCellData()
            } else {
                hourlyOrDailyForecastCell.sectionData = viewModel.prepareHourlyCellData()
            }

            hourlyOrDailyForecastCell.actionDelegate = self
            hourlyOrDailyForecastCell.collectionView.reloadData()
            cell = hourlyOrDailyForecastCell
            
        default :
            
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: Constants.titleCellReuseIdentifier, for: indexPath) as! TitleCell
            defaultCell.titleLabel.text = "DEFAULT"
            cell = defaultCell
            
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            forecastOverviewSection = .currently
            forecastOverviewIndex = -1
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height
        switch indexPath.row {
        case 0 : return height * 0.10
        case 1 : return height * 0.25
        case 2 : return height * 0.15
        case 3 : return height * 0.5
        default : return height * 0
        }
    }
    
    
}

extension ForecastViewController: HourlyOrDailyForecastCellActionDelegate {
    
    func showSelectedForecastDetails(forecastSection: ForecastSection, index: Int) {
        if forecastOverviewSection != forecastSection || forecastOverviewIndex != index {
            forecastOverviewSection = forecastSection
            forecastOverviewIndex = index
        } else {
            forecastOverviewSection = .currently
            forecastOverviewIndex = 0
        }
        
        self.actionDelegate?.updateBackgroundGradient(gradient: self.viewModel.generateBackgroundGradient(forecastSection: forecastSection, index: index))
        
        tableView.reloadData()
    }
    
    func switchForecastSection(forecastSection: ForecastSection) {
        forecastChartSection = forecastSection
        forecastOverviewSection = .currently
        forecastOverviewIndex = 0
        self.actionDelegate?.updateBackgroundGradient(gradient: self.viewModel.generateBackgroundGradient(forecastSection: forecastSection, index: 0))
        tableView.reloadData()
    }
    
    
}


