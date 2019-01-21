//
//  View.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class InitialView: UIView {
    
    lazy var titleLabelOne: UILabel = {
        let label = UILabel()
        label.customFont(size: .medium, colour: .lightGray, alignment: .center, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        label.text = "Welcome to"
        return label
    }()
    
    lazy var titleLabelTwo: UILabel = {
        let label = UILabel()
        label.text = "We'd like to acces your location!"
        label.customFont(size: .medium, colour: .lightGray, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var weatherAppLogo: UILabel = {
        let label = UILabel()
        label.text = "WEATHER APP"
        label.customFont(size: .large, colour: .white, alignment: .center, weight: .regular, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var locationServicesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Allow", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip this time", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    
    func setupView() {
        addSubview(titleLabelOne)
        addSubview(weatherAppLogo)
        addSubview(titleLabelTwo)
        addSubview(skipButton)
        addSubview(locationServicesButton)
    }
    
    func setupConstraints() {
        
        titleLabelOne.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, bottom: weatherAppLogo.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 100, left: 16, bottom: -16, right: -16), size: .init(width: 0, height: self.frame.size.height * 0.05))

        weatherAppLogo.anchor(top: titleLabelOne.bottomAnchor, leading: self.leadingAnchor, bottom: titleLabelTwo.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 16, left: 16, bottom: -16, right: -16), size: .init(width: 0, height: self.frame.size.height * 0.1))
        
        titleLabelTwo.anchor(top: weatherAppLogo.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: -16), size: .init(width: 0, height: self.frame.size.height * 0.05))
    
        skipButton.anchor(top: locationServicesButton.bottomAnchor, leading: self.leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 16, left: 64, bottom: -16, right: -64), size: .init(width: 0, height: self.frame.size.height * 0.025))
        
        locationServicesButton.anchor(top: nil, leading: self.leadingAnchor, bottom: skipButton.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 64, bottom: -16, right: -64), size: .init(width: 0, height: self.frame.size.height * 0.025))
           
    }
}

