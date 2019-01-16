//
//  LabelView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 22/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class LabelView: UIView {
    
    lazy var labelStack: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        return stackview
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .tiny, colour: .white, alignment: .left, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .small, colour: .white, alignment: .left, weight: .ultraLight, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        addSubview(labelStack)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(valueLabel)
    }
    
    func setupConstraints() {
        labelStack.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    
    func bindWith(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
        layoutIfNeeded()
        layoutSubviews()
    }
    
}
