//
//  TitleCell.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

struct TitleCellItem {
    var cityName: String
    var time: String
}

protocol TitleCellActionDelegate: class {
    func requestLocationAuthorisation()
}

class TitleCell: UITableViewCell {
    
    var cityNameAvailable = false
    weak var actionDelegate: TitleCellActionDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .large, colour: .white, alignment: .center, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .tiny, colour: .white, alignment: .center, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(dateLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        titleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: dateLabel.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: -16), size: .init(width: 0, height: 0))
        
        dateLabel.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
    }
    
    func bindWith(_ cellData: TitleCellItem) {
        if cellData.cityName != "" {
            titleLabel.text = cellData.cityName
            dateLabel.text = cellData.time
            cityNameAvailable = true
        } else {
            titleLabel.text = NSLocalizedString("Unable to retrieve your location", comment: "")
            dateLabel.text = NSLocalizedString("Click here to update settings", comment: "")
            cityNameAvailable = false
        }
    }
    
    @objc func viewTapped() {
        if !cityNameAvailable {
            actionDelegate?.requestLocationAuthorisation()
        }
    }
    
}


