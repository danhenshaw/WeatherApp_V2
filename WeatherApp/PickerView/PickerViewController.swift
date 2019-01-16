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
    
    
    init(withViewModel viewModel: PickerViewModel, pickerType: PickerType) {
        self.viewModel = viewModel
        self.pickerType = pickerType
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
        case .forecast : title = "Forecast"
        case .language : title = "Choose your language"
        case .units : title = "Choose your units"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        addNavigationItems()
        let scrollPosition = viewModel.setScrollPosition(pickerType)
        pickerView.pickerView.selectRow(scrollPosition, inComponent: 0, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addNavigationItems() {
        let rightButton = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    @objc func saveButtonTapped() {
        GlobalVariables.sharedInstance.update(value: pickerType, toNewValue: pendingValueToSave)
        GlobalVariables.sharedInstance.haveSettingsChanged(true)
        self.navigationController?.popViewController(animated: true)
    }

}



extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfItemsInSection(pickerType)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerItem = viewModel.valueItemForIndexPath(pickerType, index: row)
        let titleText = pickerItem.longName
        let myTitle = NSAttributedString(string: titleText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerItem = viewModel.valueItemForIndexPath(pickerType, index: row)
        pendingValueToSave = pickerItem.shortName
        
        if (pendingValueToSave != GlobalVariables.sharedInstance.language) || (pendingValueToSave != GlobalVariables.sharedInstance.units) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    
    
}
