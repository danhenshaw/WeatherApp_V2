//
//  SunriseSunsetCollectionViewCell.swift
//  WeatherApp
//
//  Created by Daniel Henshaw on 23/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit


class SunriseSunsetCollectionViewCell: UICollectionViewCell {
    
    lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .otherIcon, colour: .white, alignment: .center, weight: .ultraLight, fontName: .weather, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    fileprivate var topSpacer: UIView!
    fileprivate var bottomSpacer: UIView!
    
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
        topSpacer = UIView()
        bottomSpacer = UIView()
        addSubview(topSpacer)
        addSubview(iconLabel)
        addSubview(bottomSpacer)
        addSubview(timeLabel)
    }
    
    func setupConstraints() {
        
        topSpacer.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        iconLabel.anchor(top: topSpacer.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.size.height * 0.25))
        
        bottomSpacer.anchor(top: iconLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        timeLabel.anchor(top: bottomSpacer.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.size.height * 0.1))
    }
    
    
    func bindWith(_ cellData: HourlyOrDailyForecastCellItem) {
        timeLabel.text = cellData.day.uppercased()
        iconLabel.text = cellData.icon
    }
    
    
    func configFor(_ cellData: HourlyOrDailyForecastCellItem) {
        
        let cellHeight = Double(self.frame.size.height)
        
        let multiplier = (cellData.rangeMax - cellData.maxTemp) / (cellData.rangeMax - cellData.rangeMin)
        let topSpacerHeight = multiplier * 0.25
        
        topSpacer.height(constant: CGFloat(cellHeight * topSpacerHeight))
        
        layoutIfNeeded()
        layoutSubviews()
        
    }
    
    
}
