//
//  CustomiseableForecastDataViewController.swift
//  WeatherApp
//
//  Created by Daniel Henshaw on 21/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

protocol CustomiseableForecastDataViewControllerFlowDelegate: class {
    func showPickerView(_ senderViewController: CustomiseableForecastDataViewController, pickerType: PickerType, forecastSection: ForecastSection, slot: Int)
}


class CustomiseableForecastDataViewController : UITableViewController {
    
    weak var flowDelegate: CustomiseableForecastDataViewControllerFlowDelegate?
    fileprivate let viewModel: CustomiseableForecastDataViewModel
    
    struct Constants {
        static let customiseableForecastDataCellReuseIdentifier = "CustomiseableForecastDataCellReuseIdentifier"
        static let customiseableForecastDataHeaderViewReuseIdentifier = "CustomiseableForecastDataHeaderViewReuseIdentifier"
    }
    
    init(withViewModel viewModel: CustomiseableForecastDataViewModel) {
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
        tableView.register(CustomiseableForecastDataCell.self, forCellReuseIdentifier: Constants.customiseableForecastDataCellReuseIdentifier)
        tableView.register(CustomiseableForecastDataHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.customiseableForecastDataHeaderViewReuseIdentifier)
        title = NSLocalizedString("Forecast Data", comment: "")
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
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.customiseableForecastDataHeaderViewReuseIdentifier) as! CustomiseableForecastDataHeaderView
        let isCollapsed = viewModel.sectionIsCollapsed(section: section)
        view.titleLabel.text = NSLocalizedString(viewModel.headerTitle(section), comment: "")
        view.setCollapsed(isCollapsed: isCollapsed)
        view.section = section
        view.actionDelegate = self
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.clear
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customiseableForecastDataItem = viewModel.itemForIndexPath(indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.customiseableForecastDataCellReuseIdentifier, for: indexPath) as! CustomiseableForecastDataCell
        cell.bindWithItem(customiseableForecastDataItem)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickerType = viewModel.forecastTypeForSection(indexPath.section)
        flowDelegate?.showPickerView(self, pickerType: .forecast, forecastSection: pickerType, slot: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sectionIsCollapsed(section: indexPath.section) ? 0 : UITableView.automaticDimension
    }

    

    
}

extension CustomiseableForecastDataViewController: CustomiseableForecastDataHeaderViewActionDelegate {
    
    func headerTapped(_ section: Int) {
        viewModel.updatedCollapsedFor(section: section)
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        
        if !viewModel.sectionIsCollapsed(section: section) {
            tableView.scrollToRow(at: [section,0], at: .top, animated: true)
        }
    }
    
    
}
