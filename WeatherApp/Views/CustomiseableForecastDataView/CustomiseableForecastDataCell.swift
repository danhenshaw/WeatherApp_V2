//
//  CustomiseableForecastDataCell.swift
//  WeatherApp
//
//  Created by Daniel Henshaw on 21/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

class CustomiseableForecastDataCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .medium, colour: .black, alignment: .left, weight: .regular, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .lightGray, alignment: .right, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
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
        addSubview(valueLabel)
    }
    
    func setupConstraints() {
        
        valueLabel.anchor(top: contentView.topAnchor, leading: titleLabel.trailingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 4, left: 8, bottom: -4, right: -8), size: .init(width: contentView.frame.width * 0.6, height: 0))
        
        titleLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: valueLabel.leadingAnchor, padding: .init(top: 4, left: 8, bottom: -4, right: -8), size: .init(width: 0, height: 0))
        
    }
    
    
    func bindWithItem(_ item: ForecastDataItem) {
        titleLabel.text = item.title
        valueLabel.text = NSLocalizedString(item.value, comment: "")
    }
    
}
