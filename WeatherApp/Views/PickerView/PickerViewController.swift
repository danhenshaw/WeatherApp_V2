//
//  PickerViewController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class PickerViewController : UIViewController {
    
    fileprivate let viewModel: PickerViewModel
    fileprivate let pickerType: PickerType
    fileprivate var pendingValueToSave = String()
    fileprivate let forecastSection: ForecastSection?
    fileprivate let slot: Int?
    fileprivate var scrollPosition = 0
    
    
    init(withViewModel viewModel: PickerViewModel, pickerType: PickerType, forecastSection: ForecastSection?, slot: Int?) {
        self.viewModel = viewModel
        self.pickerType = pickerType
        self.forecastSection = forecastSection
        self.slot = slot
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() { view = PickerView() }
    
    var pickerView: PickerView { return self.view as! PickerView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.pickerView.dataSource = self
        pickerView.pickerView.delegate = self
        
        switch pickerType {
        case .forecast : title = NSLocalizedString("Forecast Data", comment: "")
        case .language : title = NSLocalizedString("Choose your language", comment: "")
        case .units : title = NSLocalizedString("Choose your units", comment: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        addNavigationItems()
        scrollPosition = viewModel.setScrollPosition(pickerType, forecastSection: forecastSection, slot: slot)
        pickerView.pickerView.selectRow(scrollPosition, inComponent: 0, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addNavigationItems() {
        let rightButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    @objc func saveButtonTapped() {
        GlobalVariables.sharedInstance.update(value: pickerType, forecastSection: forecastSection, slot: slot, toNewValue: pendingValueToSave)
        GlobalVariables.sharedInstance.haveSettingsChanged(true)
        self.navigationController?.popViewController(animated: true)
    }

}



extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfItemsInSection(pickerType, forecastSection: forecastSection, slot: slot)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerItem = viewModel.valueItemForIndexPath(pickerType, forecastSection: forecastSection, slot: slot, index: row)
        let titleText = NSLocalizedString(pickerItem, comment: "")
        let myTitle = NSAttributedString(string: titleText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return myTitle
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerItem = viewModel.valueToSave(pickerType, forecastSection: forecastSection, slot: slot, index: row)
        pendingValueToSave = pickerItem
        
        if row != scrollPosition {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    
    
}
