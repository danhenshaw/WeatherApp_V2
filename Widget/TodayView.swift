//
//  TodayView.swift
//  Widget
//
//  Created by Daniel Henshaw on 19/2/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

struct TodayViewItem {
    let currentTemp: String?
    let values: [LabelFormat]
}

//struct LabelFormat {
//    let title: String
//    let value: String
//}

class TodayView: UIView {
    
    lazy var labelArray = [LabelView]()
 
//      |     20°           BERLIN - Sunny          |
//      |                   Temp: High 1 Low 1      |
//      |                   Rain: 0%                |
//      |                   Wind: NE 2 km/h         |
//      ___________________________________________
//      |
//      |   ICON
//      |   TEMP
//      |
//      |   40%
//      |________
//      ||      |
//      |--NOW--
    
    lazy var compactStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .huge, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    
    lazy var expandedStackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createLabels()
        setupView()
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabels() {
        for _ in 0 ... 3 {
            let label = LabelView()
            labelArray.append(label)
            labelStack.addArrangedSubview(label)
        }
    }
    
    func setupView() {
        addSubview(compactStackView)
        compactStackView.addArrangedSubview(tempLabel)
        compactStackView.addArrangedSubview(labelStack)
        addSubview(expandedStackView)
    }
    
    func setupConstraints() {
        compactStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: expandedStackView.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 4, left: 8, bottom: -4, right: -8), size: .init(width: 0, height: 80))
        
        expandedStackView.anchor(top: compactStackView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 4, left: 8, bottom: -4, right: -8), size: .init(width: 0, height: 0))
        
        expandedStackView.isHidden = true
    }
    
    func updateView(expand: Bool) {
        expandedStackView.isHidden = expand
    }
    
    
    func bindWith(_ cellData: TodayViewItem) {
        
        tempLabel.text = cellData.currentTemp
        
        for index in 0 ..< cellData.values.count {
            let titleString = cellData.values[index].title
            if titleString != "" {
                labelArray[index].titleLabel.text = "\(NSLocalizedString(titleString, comment: "").uppercased())" + ": "
                labelArray[index].valueLabel.text = cellData.values[index].value
            }
        }
    }
    
}
