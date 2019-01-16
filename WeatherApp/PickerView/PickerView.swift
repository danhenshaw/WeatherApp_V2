//
//  PickerView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class PickerView: UIView {
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        addSubview(pickerView)
    }
    
    func setupConstraints() {
        pickerView.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 16, left: 16, bottom: -16, right: -16), size: .init(width: 0, height: 0))
    }
}

