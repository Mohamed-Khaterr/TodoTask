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
    
    private var days: [Day] = [
        Day(title: "Sun", number: "", isSelected: false),
        Day(title: "Mon", number: "", isSelected: false),
        Day(title: "Tus", number: "", isSelected: false),
        Day(title: "Wed", number: "", isSelected: false),
        Day(title: "Thu", number: "", isSelected: false),
        Day(title: "Fri", number: "", isSelected: false),
        Day(title: "Sat", number: "", isSelected: false),
    ]
    
    private var tasks: [Task] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    private var shiftDayBy = 0 {
        didSet{
            // not select all days
            for i in 0..<days.count{
                days[i].isSelected = false
            }
            
            // Get new day number
            getDaysNumber(with: shiftDayBy)
            
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
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
        tableView.delegate = self
        
        
        //------------right  swipe gestures in collectionView--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.collectionView.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in collectionView--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.collectionView.addGestureRecognizer(swipeLeft)
        
        getDaysNumber()
        
        formatter.dateFormat = "d, MMMM"
        todayLabel.text = "Today " + formatter.string(from: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", Date() as CVarArg, endDate! as CVarArg)
        
        let sortDescription = NSSortDescriptor(key: "date", ascending: true)
        
        if let fetchedTasks = CoreDataManager.shared.fetchTasks(predicate: predicate, sortDescriptor: [sortDescription]){
            tasks = fetchedTasks
        }
    }
    
    private func getDaysNumber(with shiftDay: Int = 0){
        let today = Date()
        
        let calendar = Calendar.current
        
        let dayOfWeek = calendar.component(.weekday, from: today) + 3 + shiftDay
        
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        
        formatter.dateFormat = "d"
        
        for day in weekdays{
            let dayDate = calendar.date(byAdding: .day, value: day - dayOfWeek, to: today)
            formatter.dateFormat = "d"
            days[day - 1].number = formatter.string(from: dayDate!)
            formatter.dateFormat = "E"
            days[day - 1].title = formatter.string(from: dayDate!)
            
            if dayDate == today{
                days[day - 1].isSelected = true
            }
        }
    }
    
    @objc private func rightSwiped(){
        print("Swip right")
        shiftDayBy += 1
    }
    
    @objc private func leftSwiped(){
        print("Swip left")
        shiftDayBy -= 1
    }
}


// MARK: - CollectionView DataSource
extension CalendarVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        let day = days[indexPath.row]
        
        
        cell.configure(dayTitle: day.title, dayNumber: day.number)
        
        if day.isSelected {
            cell.backgroundColor = Constant.lightBlack
            cell.dayTitleLabel.textColor = Constant.backgroundColor
            cell.dayNumberLabel.textColor = Constant.backgroundColor
        }else{
            cell.backgroundColor = .clear
            cell.dayTitleLabel.textColor = Constant.black
            cell.dayNumberLabel.textColor = Constant.black
        }
        
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension CalendarVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<days.count{
            days[i].isSelected = false
        }
        
        days[indexPath.row].isSelected = !days[indexPath.row].isSelected
        
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
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        let taskTime = formatter.string(from: task.date!)
        
        let remainingTime = Calendar.current.dateComponents([.hour], from: Date(), to: task.date!)
        
        cell.configure(time: taskTime, remainTime: String(remainingTime.hour!) + " hours", title: task.name!, descritpion: task.descritpion!)
        
        
        if indexPath.row == 0 {
            cell.firstCell()
            print("First")
        }else if tasks.count  == (indexPath.row + 1){
            cell.lastCell()
            print("Last")
        }else{
            cell.middleCell()
            print("Middle")
        }
        
        
        return cell
    }
}


// MARK: - TableView Delegate
extension CalendarVC: UITableViewDelegate{
    
}
