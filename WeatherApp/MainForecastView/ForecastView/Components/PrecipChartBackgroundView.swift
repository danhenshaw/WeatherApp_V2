//
//  PrecipChartBackgroundView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 22/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class PrecipChartBackgroundView: UIView {
    
    let intensityLabels = ["HEAVY", "", "MED", "", "LIGHT"]
    let timeLabels = ["NOW", "15", "30", "45", "60"]
    var bars: [UIView]!
    var rows: [UIView]!
    let rowStackView = UIStackView()
    var timeStackView = UIStackView()
    var barStackView: UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    func setupView() {
        
        barStackView = UIStackView()
        barStackView.axis = .horizontal
        barStackView.alignment = .bottom
        barStackView.distribution = .fillEqually
        addSubview(barStackView)
        
        bars = [UIView]()
        rows = [UIView]()
        
        // Create 60 bars to be used to show rainfall intensity for each minute in the hour
        for _ in 0 ... 60 {
            let bar = UIView()
            bar.backgroundColor = UIColor(rgb: GlobalVariables.sharedInstance.precipBlue, a: 0.3)
            bars.append(bar)
            barStackView.addArrangedSubview(bar)
        }
        
        
        // create 7 rows. 3 to show intensity labels (heavy, med, light) and 3 to be used as boarder and 1 to be used as x-axis labels
        for row in 0 ... 7 {
            let view = UIView()
            rows.append(view)
            addSubview(view)
            
            if row == 1 || row == 3 || row == 5 {
                view.backgroundColor = .white
            }
            
            if row == 0 || row == 2 || row == 4 {
                
                let label = UILabel()
                label.customFont(size: .small, colour: .white, alignment: .left, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
                label.text = intensityLabels[row]
                label.fillSuperview()
                rows[row].addSubview(label)
            }
            
            if row == 7 {
                
                timeStackView = UIStackView()
                timeStackView.axis = .horizontal
                timeStackView.distribution = .fillEqually
                
                for column in 0 ... 4 {
                    
                    let label = UILabel()
                    label.customFont(size: .tiny, colour: .white, alignment: .right, weight: .regular, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
                    label.text = timeLabels[column]
                    timeStackView.addArrangedSubview(label)
                    
                }
                
                rows[row].addSubview(timeStackView)
 
            }
            
        }
    }
    
    
    func setupConstraints() {
        rows[0].anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: rows[1].topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.25))
        
        rows[1].anchor(top: rows[0].bottomAnchor, leading: self.leadingAnchor, bottom: rows[2].topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.01))
        
        rows[2].anchor(top: rows[1].bottomAnchor, leading: self.leadingAnchor, bottom: rows[3].topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.25))
        
        rows[3].anchor(top: rows[2].bottomAnchor, leading: self.leadingAnchor, bottom: rows[4].topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.01))
        
        rows[4].anchor(top: rows[3].bottomAnchor, leading: self.leadingAnchor, bottom: rows[5].topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.25))
        
        rows[5].anchor(top: rows[4].bottomAnchor, leading: self.leadingAnchor, bottom: rows[6].topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.03))
        
        rows[6].anchor(top: rows[5].bottomAnchor, leading: self.leadingAnchor, bottom: rows[7].topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: self.frame.height * 0.05))
        
        rows[7].anchor(top: rows[6].bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        timeStackView.fillSuperview()
        
        barStackView.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.frame.width * 0.83, height: self.frame.height * 0.8))

    }
}
