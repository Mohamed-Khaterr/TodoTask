//
//  Priority.swift
//  MyTodoList
//
//  Created by Khater on 9/17/22.
//

import Foundation

enum Priority{
    case high, low, medium
    
//    static func toString(priority: Priority) -> String{
//        switch priority {
//        case .high:
//            return "High"
//        case .low:
//            return "Low"
//        case .medium:
//            return "Medium"
//        }
//    }
    
    static func stringToPriority(string: String) -> Priority{
        switch string{
        case "Low":
            return .low
        case "Medium":
            return .medium
        case "High":
            return .high
            
        default:
            fatalError("Unkown Prioriy")
        }
    }
}
