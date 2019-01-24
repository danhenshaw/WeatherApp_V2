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
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        return label
    }()
    
    lazy var arrowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.text = ">"
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
        addSubview(arrowLabel)
        addSubview(button)
    }
    
    func setupConstraints() {
        button.fillSuperview()
        titleLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: -8, right: -8), size: .init(width: 0, height: 0))
        
        arrowLabel.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 8, bottom: -8, right: -8), size: .init(width: titleLabel.frame.size.height, height: titleLabel.frame.size.height))
    }
    
    @objc func headerTapGesture() {
        actionDelegate?.headerTapped(section)
    }
    
    func setCollapsed(isCollapsed: Bool) {
        let rotationAngel = isCollapsed ? 0.0 : CGFloat.pi / 2
        arrowLabel.transform = CGAffineTransform(rotationAngle: rotationAngel)
    }
    
    
    
}
