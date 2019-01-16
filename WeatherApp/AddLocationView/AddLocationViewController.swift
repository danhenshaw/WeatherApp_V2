//
//  AddLocationViewController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 19/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreData

protocol AddLocationViewControllerActionDelegate: class {
    func userAdded(newCity: CityDataModel)
}

class AddLocationViewController: UIViewController {
    
    weak var actionDelegate: AddLocationViewControllerActionDelegate?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AddLocationView()
    }
    
    var addLocationView: AddLocationView { return self.view as! AddLocationView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        addLocationView.searchBar.delegate = self
        addLocationView.tableView.delegate = self
        addLocationView.tableView.dataSource = self
        title = "Add a new location"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLocationView.searchBar.becomeFirstResponder()
        setupNavigationBar(isTranslucent: false, hideBackButton: true)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupNavigationBar(isTranslucent: Bool, hideBackButton: Bool) {
        self.navigationItem.hidesBackButton = hideBackButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

}

extension AddLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellId")
        cell.textLabel?.text = searchResults[indexPath.row].title
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchResults.indices.contains(indexPath.row) {
            let searchRequest = MKLocalSearch.Request(completion: searchResults[0])
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                
                let newCityData = CityDataModel()
                newCityData.latitude = response?.mapItems[0].placemark.coordinate.latitude ?? 0
                newCityData.longitude = response?.mapItems[0].placemark.coordinate.longitude ?? 0
                newCityData.cityName = response?.mapItems[0].placemark.locality ?? "City name unavailable"

                CoreDataStack.shared.add(cityData: newCityData)
                self.actionDelegate?.userAdded(newCity: newCityData)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}


extension AddLocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults.removeAll()
        let digitsCharacterSet = NSCharacterSet.decimalDigits
        let filteredResults = searchCompleter.results.filter( { $0.title.rangeOfCharacter(from: digitsCharacterSet) == nil && $0.subtitle.rangeOfCharacter(from: digitsCharacterSet) == nil})
        searchResults = filteredResults 
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
    
}




extension AddLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        addLocationView.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }

}
