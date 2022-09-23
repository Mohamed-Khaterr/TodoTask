//
//  Extensions.swift
//  MyTodoList
//
//  Created by Khater on 9/17/22.
//

import Foundation
import UIKit


extension UIView{
    func cornerRadius(with degree: CGFloat? = nil){
        self.layer.masksToBounds = true
        if let safeDegree = degree {
            self.layer.cornerRadius = safeDegree
        }else{
            self.layer.cornerRadius = self.frame.size.height / 2
        }
    }
}


extension UIColor {

    public func adjust(hueBy hue: CGFloat = 0, saturationBy saturation: CGFloat = 0, brightnessBy brightness: CGFloat = 0) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue + hue,
                       saturation: currentSaturation + saturation,
                       brightness: currentBrigthness + brightness,
                       alpha: currentAlpha)
        } else {
            return self
        }
    }
}


extension UITextField{
    // increase the opacity of Placeholder
    @IBInspectable var placeHolderOpacity: CGFloat{
        set{
            if let placeholderTitle = self.placeholder{
                self.attributedPlaceholder = NSAttributedString(string: placeholderTitle, attributes: [NSAttributedString.Key.foregroundColor: Constant.black!.withAlphaComponent(newValue)])
            }
        }

        get{
            return self.placeHolderOpacity
        }
    }
}
