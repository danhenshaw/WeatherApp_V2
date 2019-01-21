//
//  NavigationController.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
}
