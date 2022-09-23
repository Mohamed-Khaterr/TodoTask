//
//  Priority.swift
//  MyTodoList
//
//  Created by Khater on 9/17/22.
//

import Foundation

enum Priority{
    case high, low, medium
    
    static func toString(priority: Priority) -> String{
        switch priority {
        case .high:
            return "High"
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        }
    }
}
