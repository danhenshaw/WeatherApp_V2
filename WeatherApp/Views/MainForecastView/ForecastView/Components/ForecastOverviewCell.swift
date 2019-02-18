//
//  ForecastOverviewCell.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

struct ForecastOverviewCellItem {
    let currentTemp: String?
    let values: [LabelFormat]
}

struct LabelFormat {
    let title: String
    let value: String
}

class ForecastOverviewCell: UITableViewCell {
    
    lazy var labelStackLeft: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.axis = .vertical
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    lazy var labelStackRight: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.axis = .vertical
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        stackview.spacing = 24
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .huge, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var labelArray = [LabelView]()
    
    var titleLabels: [UILabel]!
    var valueLabels: [UILabel]!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createLabels()
        setupView()
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    func createLabels() {

        for index in 0 ..< 8 {
            
            let label = LabelView()
            labelArray.append(label)
            
            if index <= 3 {
                labelStackLeft.addArrangedSubview(label)
            } else {
                labelStackRight.addArrangedSubview(label)
            }
        }
    }
    
    func setupView() {
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(labelStackLeft)
        stackView.addArrangedSubview(labelStackRight)
        addSubview(stackView)
    }
    
    func setupConstraints() {

        let multiplier = ((superview?.frame.size.height ?? 568) / 568 * 2.5)
        
        stackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 12 * multiplier, left: 8, bottom: -12 * multiplier, right: -8), size: .init(width: 0, height: 0))
        
    }
    
    
    func bindWith(_ cellData: ForecastOverviewCellItem) {
        
        tempLabel.text = cellData.currentTemp
        for index in 0 ..< cellData.values.count {
            let titleString = cellData.values[index].title
            if titleString != "" {
                labelArray[index].titleLabel.text = "\(NSLocalizedString(titleString, comment: "").uppercased())" + ": "
                labelArray[index].valueLabel.text = cellData.values[index].value
            }
        }
    }
    
    func configureCell(_ forecastSection: ForecastSection) {

        if forecastSection == .currently {
            labelStackRight.isHidden = true
            labelStackLeft.isHidden = false
            tempLabel.isHidden = false
        } else {
            labelStackRight.isHidden = false
            labelStackLeft.isHidden = false
            tempLabel.isHidden = true
        }
    }
    
}



