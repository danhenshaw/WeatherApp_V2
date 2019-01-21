//
//  LocationListView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 10/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

class LocationListView: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.orange.cgColor, UIColor.purple.cgColor]
        return gradient
    }()
    
    lazy var blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    var backgroundGradient = [UIColor.orange.cgColor, UIColor.purple.cgColor]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        layer.addSublayer(gradientLayer)
        addSubview(blurEffect)
        addSubview(tableView)
        backgroundColor = .clear
        
    }
    
    func setupConstraints() {
        tableView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        gradientLayer.frame = self.bounds
    }
}
