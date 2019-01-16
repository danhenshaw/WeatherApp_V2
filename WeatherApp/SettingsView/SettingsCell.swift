//
//  SettingsCell.swift
//  WeatherApp_V5
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    lazy var labelStack: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillProportionally
        stackview.axis = .vertical
        return stackview
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .medium, colour: .black, alignment: .left, weight: .regular, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .tiny, colour: .darkGray, alignment: .left, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .lightGray, alignment: .right, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
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
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(detailLabel)
        contentView.addSubview(labelStack)
        contentView.addSubview(valueLabel)
    }
    
    func setupConstraints() {
        
        valueLabel.anchor(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 4, left: 4, bottom: -4, right: -8), size: .init(width: contentView.frame.width * 0.25, height: 0))

        labelStack.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: valueLabel.leadingAnchor, padding: .init(top: 4, left: 8, bottom: -4, right: -4), size: .init(width: 0, height: 0))
        
    }
    
    
    func bindWithSettingItem(_ settingItem: SettingItem) {
        titleLabel.text = settingItem.title
        detailLabel.text = settingItem.subTitle
    }
    
    
    func configureCellForSettingItem(_ settingItem: SettingItem) {
        
        switch settingItem.type {
        case .externalLink:

            accessoryType = .none
            tintColor = UIColor.black
            selectionStyle = .gray
        case .internalSegue:
            accessoryType = .disclosureIndicator
            tintColor = UIColor.black
            selectionStyle = .gray
        }
        
        switch settingItem.hideSubTitleLabel {
        case true:
            detailLabel.isHidden = true
        case false:
            detailLabel.isHidden = false
        }
        
    }
    
}

