//
//  TESTMainView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 19/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    lazy var pageViewController: UIPageViewController = {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageView
    }()
    
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        return page
    }()
    
    lazy var advertisementView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var advertisementLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "ADVERTISEMENT"
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.orange.cgColor, UIColor.purple.cgColor]
        return gradient
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
        layer.addSublayer(gradientLayer)
        addSubview(pageViewController.view)
        addSubview(advertisementView)
        addSubview(pageControl)
        advertisementView.addSubview(advertisementLabel)
    }
    
    func setupConstraints() {
        
        pageViewController.view.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.75))
        
        pageControl.anchor(top: pageViewController.view.bottomAnchor, leading: self.leadingAnchor, bottom: advertisementView.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.05))
        
        advertisementView.anchor(top: pageControl.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        gradientLayer.frame = self.bounds
        advertisementLabel.fillSuperview()
        
    }
 
}
