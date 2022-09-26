//
//  CoreDataManager.swift
//  MyTodoList
//
//  Created by Khater on 9/21/22.
//

import Foundation
import UIKit
import CoreData


struct CoreDataManager{
    
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func fetchCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) -> [Category]? {
        
        do {
            let result = try context.fetch(request)
            
            
            return result
        }catch {
            return nil
        }
    }
    
    func fetchTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil, sortDescriptor: [NSSortDescriptor]? = nil) -> [Task]?{
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = sortDescriptor
        }
        
        do {
            let result = try context.fetch(request)
            
            return result
        }catch {
            return nil
        }
    }
    
    public func saveData() -> Bool{
        do {
            try context.save()
            
            return true
        } catch {
            return false
        }
    }
    
    public func delete(category: Category? = nil, task: Task? = nil) -> Bool{
        if let category = category {
            context.delete(category)
        }
        
        if let task = task {
            context.delete(task)
        }
        
        return saveData()
    }
    
}
