//
//  AddLocationView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 19/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class AddLocationView: UIView {
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.showsCancelButton = true
        search.sizeToFit()
        search.isUserInteractionEnabled = true
        search.placeholder = "Search for places"
        return search
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        
        searchBar.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.1))
        
        tableView.anchor(top: searchBar.bottomAnchor, leading: self.leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
    }
}
