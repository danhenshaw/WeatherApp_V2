//
//  SettingsHeaderView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 22/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class SettingsHeaderView : UITableViewHeaderFooterView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    
    func setupView() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -8, right: 0), size: .init(width: 0, height: 0))
    }
    
    
    
}
