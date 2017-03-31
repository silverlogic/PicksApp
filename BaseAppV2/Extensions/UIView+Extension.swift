//
//  UIView+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/11/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

extension UIView {
    
    /**
        Performs an animation for changing the root view controller
        of the application.
     
        - Parameter snapshot: A `UIView` representing the snapshot of the current window
                              to apply the animation.
    */
    static func performRootViewControllerAnimation(snapshot: UIView) {
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
        });
    }
}


// MARK: - Show/Hide Animation
extension UIView {
    
    /// Animates showing an instance.
    func animateShow() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 1
        }
    }
    
    /// Animates hiding an instance.
    func animateHide() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 0
        }
    }
}
