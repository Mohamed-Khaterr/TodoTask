//
//  ViewController.swift
//  MyTodoList
//
//  Created by Khater on 9/17/22.
//

import UIKit
import SwipeCellKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sortDescritptorPriority = NSSortDescriptor(key: "priority", ascending: true)
        let sortDescritpitorDate = NSSortDescriptor(key: "date", ascending: true)
        if let fetchedTasks = CoreDataManager.shared.fetchTasks(sortDescriptor: [sortDescritptorPriority, sortDescritpitorDate]){
            self.tasks = fetchedTasks
            tableView.reloadData()
        }
    }

    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
    }
}

// MARK: - TableView DataSource
extension HomeVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "d MMM, E"
        let currentDate = dateFormat.string(from: .now)
        
       return "Today, \(currentDate)."
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.isEmpty{
            return 1
        }
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        
        cell.delegate = self
        
        if tasks.isEmpty{
            cell.taskLabel.text = "No Tasks"
            cell.categoryView.isHidden = true
            cell.priorityLabel.isHidden = true
            cell.checkBoxImageView.isHidden = true
            return cell
        }else{
            cell.categoryView.isHidden = false
            cell.priorityLabel.isHidden = false
            cell.checkBoxImageView.isHidden = false
        }
        
        cell.selectionStyle = .none
        
        let task = tasks[indexPath.row]
        
        if let taskName = task.name, let categoryName = task.parentCategory?.name, let color = task.parentCategory?.color, let date = task.date, let taskPriority = task.priority{
            var priority = Priority.low
            
            switch taskPriority{
            case "Low":
                priority = .low
            case "Medium":
                priority = .medium
            case "High":
                priority = .high
                
            default:
                break
            }
            
            
            cell.configuare(task: taskName, category: categoryName, categoryColor: UIColor(named: color) ?? .clear, date: date, priority: priority)
            
            cell.checkBoxImageView.image = task.isDone ? UIImage(named: Constant.checkBox.fill) : UIImage(named: Constant.checkBox.notFill)
        }
        
        
        return cell
    }
}


// MARK: - SwipKit TableViewCell Delegate
extension HomeVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left{
            let doneAction = SwipeAction(style: .default, title: "Done!") { action, indexPath in
                self.tasks[indexPath.row].isDone = !self.tasks[indexPath.row].isDone
                
                if CoreDataManager.shared.saveData() {
                    // Saved successfully
                    self.tableView.reloadData()
                }
            }
            
            doneAction.backgroundColor = UIColor(red: 0.76, green: 0.92, blue: 0.87, alpha: 1.00)
            doneAction.textColor = Constant.black
            doneAction.font = UIFont.boldSystemFont(ofSize: 16)
            
            doneAction.title = self.tasks[indexPath.row].isDone ? "Not Done!" : "Done!"
            
            return [doneAction]
        }
        
        if orientation == .right{
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                if CoreDataManager.shared.delete(task: self.tasks[indexPath.row]){
                    print("Deleted Successfuly")
                    self.tasks.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
            
            return [deleteAction]
        }
        
        
        
        
        return nil
    }
}
