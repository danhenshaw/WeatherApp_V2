//
//  SettingsHeaderView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 22/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

protocol CustomiseableForecastDataHeaderViewActionDelegate: class {
    func headerTapped(_ section: Int)
}

class CustomiseableForecastDataHeaderView : UITableViewHeaderFooterView {
    
    weak var actionDelegate: CustomiseableForecastDataHeaderViewActionDelegate?
    var section: Int = 0
    
    lazy var button: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(headerTapGesture), for: .touchUpInside)
        return b
    }()
    
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
        addSubview(button)
    }
    
    func setupConstraints() {
        button.fillSuperview()
        titleLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: -8, right: 0), size: .init(width: 0, height: 0))
    }
    
    @objc func headerTapGesture() {
        actionDelegate?.headerTapped(section)
    }
    
    func setCollapsed(collapsed: Bool) {
        // Animate the arrow rotation (see Extensions.swf)
//        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    }
    
    
    
}
