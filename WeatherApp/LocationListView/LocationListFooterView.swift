//
//  LocationListFooterView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 15/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

class LocationListFooterView : UITableViewHeaderFooterView {
    
    lazy var darkSkyButton: UIButton = {
        let width = 240.0
        let height = width * 0.22656716417
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        button.setBackgroundImage(UIImage(named: "darkbackground"), for: .normal)
        button.addTarget(self, action: #selector(darkSkyButtonTapped), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    
    func setupView() {
        addSubview(darkSkyButton)
    }
    
    func setupConstraints() {
        darkSkyButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0).isActive = true
        darkSkyButton.center.x = self.center.x
    }
    
    @objc func darkSkyButtonTapped() {
        UIApplication.shared.open(URL(string: "https://darksky.net/poweredby/")! as URL, options: [:], completionHandler: nil)
    }
    
}
