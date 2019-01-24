//
//  NewDayCollectionViewCell.swift
//  WeatherApp
//
//  Created by Daniel Henshaw on 23/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit


class NewDayCollectionViewCell: UICollectionViewCell {
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        label.customFont(size: .small, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
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
        addSubview(dayLabel)
    }
    
    func setupConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: contentView.centerXAnchor, multiplier: 0).isActive = true
        dayLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: contentView.centerYAnchor, multiplier: 0).isActive = true
        dayLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.height, height: contentView.frame.size.width)
    }
    
    
    func bindWith(_ cellData: HourlyOrDailyForecastCellItem) {
        dayLabel.text = cellData.day.uppercased()
    }

    
}
