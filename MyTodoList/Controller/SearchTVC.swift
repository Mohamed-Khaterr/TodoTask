//
//  SearchTVC.swift
//  MyTodoList
//
//  Created by Khater on 9/27/22.
//

import UIKit
import SwipeCellKit

enum SelectedSearch{
    case task, category
}

class SearchTVC: UIViewController {
    
    static let identifier: String = "SearchPage"
    
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lineView: UIView!
    
    private var tasks: [Task] = []
    
    private var categories: [Category] = []
    
    private var selectedSearch: SelectedSearch = .task{
        didSet{
            UIView.animate(withDuration: 0.3) {
                switch self.selectedSearch {
                case .task:
                    self.taskButton.backgroundColor =  Constant.lightBlue
                    self.taskButton.setTitleColor(UIColor.black, for: .normal)
                    
                    self.categoryButton.backgroundColor =  Constant.black
                    self.categoryButton.setTitleColor(Constant.backgroundColor, for: .normal)
                    
                case .category:
                    self.categoryButton.backgroundColor =  Constant.lightBlue
                    self.categoryButton.setTitleColor(UIColor.black, for: .normal)
                    
                    self.taskButton.backgroundColor =  Constant.black
                    self.taskButton.setTitleColor(Constant.backgroundColor, for: .normal)
                }
                
                self.searchBar.text = nil
                
            }
            
            let raito: Double = (selectedSearch == .task) ? -1 : 1
            makeAnimation(direction: raito)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        selectedSearch = .task
    }
    
    @IBAction func stackButtonsPressed(_ sender: UIButton) {
        if sender.currentTitle == "Task"{
            selectedSearch = .task

        }else if sender.currentTitle == "Category"{
            selectedSearch = .category
        }
    }
    
    private func makeAnimation(direction: Double){
        let ratio = (direction > 0) ? 4.7 : 4.9
        UIView.animate(withDuration: 0.4) {
            self.lineView.transform.tx = (self.view.frame.width / ratio) * direction
            self.tableView.alpha = 0
            self.tableView.transform.tx = 200 * direction
            
        }completion: { _ in
            self.tableView.transform.tx = 0
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1
            }
            
            self.tableView.reloadData()
        }
    }
}


// MARK: - TableView DataSource
extension SearchTVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (selectedSearch == .task) ? tasks.count : categories.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVCCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        switch selectedSearch {
        case .task:
            cell.textLabel?.text = tasks[indexPath.row].name
            
        case .category:
            cell.textLabel?.text = categories[indexPath.row].name
        }
        

        return cell
    }
}


// MARK: - SearchBar Delegate
extension SearchTVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "name CONTAINS %@", argumentArray: [searchText])
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        switch selectedSearch {
        case .task:
            if let fetchedTasks = CoreDataManager.shared.fetchTasks(predicate: predicate, sortDescriptor: [sortDescriptor]){
                self.tasks = fetchedTasks
            }
            
        case .category:
            if let fetchedCategories = CoreDataManager.shared.fetchCategories(predicate: predicate, sortDescriptor: [sortDescriptor]){
                self.categories = fetchedCategories
            }
        }
        
        
        self.tableView.reloadData()
    }
}

// MARK: - SwipeCell Delegate
extension SearchTVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            switch self.selectedSearch{
            case .task:
                CoreDataManager.shared.delete(task: self.tasks[indexPath.row]) ? (print("Delete Task Success")) : (nil)
                self.tasks.remove(at: indexPath.row)
                
            case .category:
                CoreDataManager.shared.delete(category: self.categories[indexPath.row]) ? (print("Delete Category Success")) : (nil)
                self.categories.remove(at: indexPath.row)
            }
            
            self.tableView.reloadData()
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            switch self.selectedSearch{
            case .task:
                print("Edite")
            case .category:
                print("Edite")
            }
        }
        
        return [deleteAction, editAction]
    }
}
