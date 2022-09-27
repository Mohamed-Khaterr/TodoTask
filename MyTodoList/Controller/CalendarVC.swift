//
//  CalendarVC.swift
//  MyTodoList
//
//  Created by Khater on 9/25/22.
//

import UIKit
import CoreData

class CalendarVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    private var days: [Day] = []
    
    private var tasks: [Task] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    private var shiftCalendarBy: Int = 0 {
        didSet{
            getWeekDays(shifting: shiftCalendarBy)
        }
    }
    
    private let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CalendarCollectionViewCell.nib(), forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.register(CalendarTaskTableViewCell.nib(), forCellReuseIdentifier: CalendarTaskTableViewCell.identifier)
        tableView.dataSource = self
        
        updateTodayLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchSelectedDateTasks()
        
        getWeekDays()
    }
    
    
    @IBAction func rightArrowButtonPressed(_ sender: UIButton) {
        shiftCalendarBy += 1
    }
    
    
    @IBAction func leftArrowButtonPressed(_ sender: UIButton) {
        shiftCalendarBy -= 1
    }
}

// MARK: - Data Minpulation
extension CalendarVC{
    private func updateTodayLabel(date: Date? = nil){
        if let date = date {
            formatter.dateFormat = "E d, MMMM"
            todayLabel.text = formatter.string(from: date)
        }else{
            formatter.dateFormat = "d, MMMM"
            todayLabel.text = "Today " + formatter.string(from: Date())
        }
    }
    
    private func fetchSelectedDateTasks(_ date: Date = Date()){
        guard let endDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: date) else { return }
        
        var predicate = NSPredicate()
        
        if Calendar.current.isDateInToday(date){
            // Current Date
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", date as CVarArg, endDay as CVarArg)
        }else{
            // if User Select Date
            if let startDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date){
                // if User Select Date
                predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDay as CVarArg, endDay as CVarArg)
            }
        }
        
        let sortDescription = NSSortDescriptor(key: "date", ascending: true)
        
        if let fetchedTasks = CoreDataManager.shared.fetchTasks(predicate: predicate, sortDescriptor: [sortDescription]){
            tasks = fetchedTasks
            
            self.tableView.reloadData()
        }
    }
    
    private func getWeekDays(shifting shiftBy: Int = 0){
        for i in 0..<7{
            // Get Dates of each day (7 days)
            if let dayDate = Calendar.current.date(byAdding: .day, value: (i - 7) + 4 + shiftBy, to: Date()){
                if days.count < 8{
                    days.append(Day(date: dayDate, isSelected: false))
                }else{
                    days[i].date = dayDate
                }
                
                days[i].isSelected = (Calendar.current.isDateInToday(dayDate)) ? true : false
            }
        }
        
        
        self.collectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            self.collectionView.reloadSections(indexSet)
        }, completion: nil)
    }
}



// MARK: - CollectionView DataSource
extension CalendarVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        let day = days[indexPath.row]
        
        formatter.dateFormat = "E"
        let dayTitle = formatter.string(from: day.date)
        
        formatter.dateFormat = "d"
        let dayNumber = formatter.string(from: day.date)
        
        cell.configure(dayTitle: dayTitle, dayNumber: dayNumber, isSelected: day.isSelected)
        

        
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension CalendarVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // UnSelect all Days
        for i in 0..<days.count{
            days[i].isSelected = false
        }
        
        // Select Tabed Day
        days[indexPath.row].isSelected = !days[indexPath.row].isSelected
        
        fetchSelectedDateTasks(days[indexPath.row].date)
        
        if Calendar.current.isDateInToday(days[indexPath.row].date){
            updateTodayLabel()
        }else{
            updateTodayLabel(date: days[indexPath.row].date)
        }
        
        self.collectionView.reloadData()
    }
}


// MARK: - CollectionView Flow Layout
extension CalendarVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.11, height: self.collectionView.frame.height * 0.95)
    }
}



// MARK: - TableView DataSource
extension CalendarVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CalendarTaskTableViewCell.identifier, for: indexPath) as! CalendarTaskTableViewCell
        
        let task = tasks[indexPath.row]
        
        formatter.dateFormat = "h:mm a"
        let taskTime = formatter.string(from: task.date!)
        
        let timeRemaining = Calendar.current.dateComponents([.hour], from: Date(), to: task.date!).hour!
        
        cell.configure(time: taskTime, remainTime: String(timeRemaining) + " hours", title: task.name!, descritpion: task.descritpion!)
        
        if tasks.count == 1{
            cell.onlyOneCell()
            
        }else if indexPath.row == 0 {
            cell.firstCell()
            
        }else if tasks.count  == (indexPath.row + 1){
            cell.lastCell()
            
        }else{
            cell.middleCell()
        }
        
        
        return cell
    }
}
