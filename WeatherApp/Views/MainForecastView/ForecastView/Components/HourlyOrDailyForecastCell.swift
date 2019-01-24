//
//  HourlyOrDailyForecastCell.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

enum CollectionViewCellType {
    case hourly, daily, newDay, sunrise, sunset
}

struct HourlyOrDailyForecastCellItem {
    var precip: Double
    var maxTemp: Double
    var minTemp: Double?
    var icon: String
    var day: String
    var rangeMax: Double
    var rangeMaxLow: Double?
    var rangeMin: Double
    var rangeMinLow: Double?
    var cellType: CollectionViewCellType
    var index: Int?
}

protocol CollectionViewCellActionDelegate: class {
    func showSelectedForecastDetails(forecastSection: ForecastSection, index: Int)
}


class CollectionViewCell: UICollectionViewCell {
    
    lazy var button: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var precipLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .blue, alignment: .center, weight: .regular, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .white, alignment: .center, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var minTempLabel: UILabel = {
        let label = UILabel()
    label.customFont(size: .small, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
//        label.customFont(size: .weatherIcon, colour: .white, alignment: .center, weight: .regular, fontName: .weather, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var precipBar: UIView = {
        let view = UIView()
        let rgb = 0x00abff
        view.backgroundColor = UIColor(rgb: GlobalVariables.sharedInstance.precipBlue, a: 0.3)
        return view
    }()
    
    fileprivate var topSpacer: UIView!
    fileprivate var bottomSpacer: UIView!
    var index = 0
    var forecastSection: ForecastSection = .daily
    weak var actionDelegate: CollectionViewCellActionDelegate?
    
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
        addSubview(maxTempLabel)
        addSubview(iconLabel)
        addSubview(minTempLabel)
        addSubview(bottomSpacer)
        addSubview(precipLabel)
        addSubview(precipBar)
        addSubview(dayLabel)
        addSubview(button)

    }
    
    func setupConstraints() {
        
        dayLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))

        precipBar.anchor(top: nil, leading: self.leadingAnchor, bottom: dayLabel.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 1, bottom: 0, right: -1), size: .init(width: 0, height: 0))

        precipLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: precipBar.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))

        bottomSpacer.anchor(top: nil, leading: self.leadingAnchor, bottom: precipLabel.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))

        minTempLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: bottomSpacer.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))

        iconLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: minTempLabel.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: -2), size: .init(width: 0, height: 0))

        maxTempLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: iconLabel.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))

        topSpacer.anchor(top: nil, leading: self.leadingAnchor, bottom: maxTempLabel.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        button.fillSuperview()

    }
    
    @objc func viewTapped() {
        actionDelegate?.showSelectedForecastDetails(forecastSection: forecastSection, index: index)
    }
    
    
    func bindWith(_ cellData: HourlyOrDailyForecastCellItem) {
        precipLabel.text = "\(Int(cellData.precip * 100))%"
        maxTempLabel.text = "\(Int(cellData.maxTemp))°"
        iconLabel.text = cellData.icon
        dayLabel.text = cellData.day.uppercased()
        index = cellData.index ?? 0
        
        if cellData.cellType == .daily {
            forecastSection = .daily
        } else {
            forecastSection = .hourly
        }
        
        if let minTemp = cellData.minTemp {
            minTempLabel.text = "\(Int(minTemp))°"
        } else {
            minTempLabel.text = ""
        }
    }

    
    
    func configFor(_ cellData: HourlyOrDailyForecastCellItem) {
        
        let weatherIconArray = ["I", "\"", "\"", "!", "$", "0", "9", "B", "<"]

        if weatherIconArray.contains(cellData.icon) {
            iconLabel.customFont(size: .weatherIcon, colour: .white, alignment: .center, weight: .regular, fontName: .weather, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        } else {
            iconLabel.customFont(size: .otherIcon, colour: .white, alignment: .center, weight: .regular, fontName: .weather, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        }

        let cellHeight = Double(self.frame.size.height)
        let precipHeight = Double(cellData.precip) * 0.2

        precipBar.height(constant: CGFloat(cellHeight * precipHeight))
        precipLabel.height(constant: CGFloat(cellHeight * 0.1))
        maxTempLabel.height(constant: CGFloat(cellHeight * 0.1))
        minTempLabel.height(constant: CGFloat(cellHeight * 0.1))
        dayLabel.height(constant: CGFloat(cellHeight * 0.1))

        if cellData.minTemp == nil { // SETUP HOURLY CELL

            iconLabel.height(constant: CGFloat(cellHeight * 0.15))
            iconLabel.backgroundColor = .clear

            let multiplier = (cellData.rangeMax - cellData.maxTemp) / (cellData.rangeMax - cellData.rangeMin)
            let topSpacerHeight = multiplier * 0.25
            let bottomSpacerHeight = 1 * 0.25 - topSpacerHeight

            bottomSpacer.height(constant: CGFloat(cellHeight * bottomSpacerHeight + cellHeight * (0.2 - precipHeight)))

            
        } else { // SETUP DAILY CELL

            let maxTempHeightMultiplier = (cellData.rangeMax - cellData.maxTemp) / (cellData.rangeMax - (cellData.rangeMaxLow ?? 0))
            
            let partOne = ((cellData.rangeMinLow ?? 0) - (cellData.minTemp ?? 0))
            let partTwo = (cellData.rangeMin - (cellData.rangeMinLow ?? 0))
            let minTempHeightMultiplier = partOne / partTwo

            let topSpacerHeight = maxTempHeightMultiplier * 0.4 / 3
            let bottomSpacerHeight = minTempHeightMultiplier * 0.4 / 3 * -1
            let iconLabelHeight = 1 * 0.4 - topSpacerHeight - bottomSpacerHeight

            bottomSpacer.height(constant: CGFloat(cellHeight * bottomSpacerHeight + cellHeight * (0.2 - precipHeight)))

            iconLabel.height(constant: CGFloat(cellHeight * iconLabelHeight))
            iconLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)

        }
        layoutIfNeeded()
        layoutSubviews()

    }
    
}

