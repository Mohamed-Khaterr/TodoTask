//
//  Constant.swift
//  MyTodoList
//
//  Created by Khater on 9/17/22.
//

import Foundation
import UIKit


struct Constant{
    // MARK: - Main Colors
    static let mandysPink = UIColor(named: "Mandys Pink")
    static let black = UIColor(named: "Black")
    static let lightBlack = UIColor(named: "Light-Black")
    static let lightBlue = UIColor(named: "Light-Blue")
    static let midGreen = UIColor(named: "Mid-Green")
    static let midRed = UIColor(named: "Mid-Red")
    static let backgroundColor = UIColor(named: "background Color")
    
    // MARK: - TabBar Images
    static let plusButton = "Plus Button"
    
    // MARK: - CheckBox Images
//    static let checked = UIImage(named: "checked")
//    static let notChecked = UIImage(named: "unchecked")
    static let checkBox = Image(fill: "checked", notFill: "unchecked")
}


struct Image {
    let fill: String
    let notFill: String
}
