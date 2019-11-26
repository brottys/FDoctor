//
//  Extensions.swift
//  FDoctor
//
//  Created by BrottyS on 26.11.2019.
//  Copyright © 2019 BrottyS. All rights reserved.
//

import UIKit

extension UIView {

    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
}
