//
//  LocationListHeaderView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 15/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

class LocationListHeaderView : UITableViewHeaderFooterView {
    
    lazy var button: UIButton = {
        let b = UIButton()
        return b
    }()
    
    lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .large, colour: .white, alignment: .left, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var currentLocationIcon: UIView = {
        let locationIcon = UIView()
        let image = UIImage(named: "location")
        let imageView = UIImageView(image: image!)
        imageView.tintColor = .white
        imageView.fillSuperview()
        locationIcon.addSubview(imageView)
        return locationIcon
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .tiny, colour: .white, alignment: .left, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .white, alignment: .left, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .huge, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var backgroundAlpha: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
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
        addSubview(backgroundAlpha)
        addSubview(timeLabel)
        addSubview(cityNameLabel)
        addSubview(summaryLabel)
        addSubview(tempLabel)
        addSubview(button)
    }
    
    func setupConstraints() {
        
        button.fillSuperview()
        
        backgroundAlpha.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 4, left: 16, bottom: -4, right: -16), size: .init(width: 0, height: 0))
        
        
        tempLabel.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 4, left: 16, bottom: -4, right: -20), size: .init(width: self.frame.width * 0.35, height: 0))
        
        timeLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: tempLabel.leadingAnchor, padding: .init(top: 12, left: 24, bottom: -4, right: -4), size: .init(width: 0, height: self.frame.height * 0.15))

        cityNameLabel.anchor(top: timeLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: tempLabel.leadingAnchor, padding: .init(top: 4, left: 24, bottom: -4, right: -4), size: .init(width: 0, height: 0))
        
        summaryLabel.anchor(top: cityNameLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: tempLabel.leadingAnchor, padding: .init(top: 4, left: 24, bottom: -12, right: -4), size: .init(width: 0, height: self.frame.height * 0.25))
        
        currentLocationIcon.isHidden = true
        
    }
    
    
    func bindWithLocationListItem(_ locationListItem: LocationListItem) {
        cityNameLabel.text = locationListItem.cityName
        currentLocationIcon.isHidden = false
        if locationListItem.time == nil {
            timeLabel.text = "Forecast currently unavailable"
        } else {
            timeLabel.text = locationListItem.time
            tempLabel.text = locationListItem.temp
            summaryLabel.text = locationListItem.summary
        }
        
        if locationListItem.isBackgroundDark ?? false {
            backgroundAlpha.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        } else {
            backgroundAlpha.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        }
    }
    
    
}
