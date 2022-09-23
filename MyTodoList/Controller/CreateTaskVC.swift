//
//  CrteateTaskVC.swift
//  MyTodoList
//
//  Created by Khater on 9/18/22.
//

import UIKit

class CreateTaskVC: UIViewController {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescritpitonTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var alarmTextField: UITextField!
    
    
    @IBOutlet weak var lowPriorityButton: UIButton!
    @IBOutlet weak var mediumPriorityButton: UIButton!
    @IBOutlet weak var highPriorityButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectedPriority: String = ""
    
    private var tasks: [Task] = []
    
    
    private var categories: [Category] = []
    private var selectedCategory: (category: Category?, isSelected: Bool) = (nil, false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CreateTaskCollectionViewCell.nib(), forCellWithReuseIdentifier: CreateTaskCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        taskNameTextField.delegate = self
        taskDescritpitonTextField.delegate = self
        
        setupUI()
        
        if let fetchedTasks = CoreDataManager.shared.fetchTasks(){
            self.tasks = fetchedTasks
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
        if let fetchedCategories = CoreDataManager.shared.fetchCategories(){
            self.categories = fetchedCategories
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - SetUp the UI
    private func setupUI(){
        // Date and Alarm Setup
        setupTextFieldWithDatePicker(textField: dateTextField, datePickerMode: .date)
        setupTextFieldWithDatePicker(textField: alarmTextField, datePickerMode: .time)
        
        
        // Priority Buttons Setups
        setupPriorityButtons(button: lowPriorityButton, color: Constant.midGreen!)
        setupPriorityButtons(button: mediumPriorityButton, color: Constant.mandysPink!)
        setupPriorityButtons(button: highPriorityButton, color: Constant.midRed!)
    }
    
    private func setupPriorityButtons(button: UIButton, color: UIColor){
        button.cornerRadius(with: 10)
        button.layer.borderWidth = 3
        button.layer.borderColor = color.cgColor
    }
    
    private func setupTextFieldWithDatePicker(textField: UITextField, datePickerMode: UIDatePicker.Mode){
        // Done Button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneToolBarButtonPressed))
        toolBar.setItems([doneButton], animated: true)
        
        textField.inputAccessoryView = toolBar
        
        // Picker Type
        let picker = UIDatePicker()
        picker.datePickerMode = datePickerMode
        picker.preferredDatePickerStyle = .wheels
        picker.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.3)
        
        if datePickerMode == .time{
            picker.addTarget(self, action: #selector(timeChange(timePicker:)), for: .valueChanged)
        }else if datePickerMode == .date{
            picker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        }
        
        textField.inputView = picker
    }
    
    
    // MARK: - Bottons Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem){
        tabBarController?.dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 0
    }
    
    
    @objc func dateChange(datePicker: UIDatePicker){
        dateTextField.text = stringDate(date: datePicker.date, format: "dd MMMM yyyy")
    }
    
    @objc func timeChange(timePicker: UIDatePicker){
        alarmTextField.text = stringDate(date: timePicker.date, format: "h:mm a")
    }
    
    @objc func doneToolBarButtonPressed(){
        self.view.endEditing(true)
    }
    
    private func stringDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        if sender.isOn{
            print("is On")
        }else{
            print("is Off")
        }
    }
    
    @IBAction func priorityButtonPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else {
//            fatalError("No Title for Priority Buttons")
            return
        }
        
        if selectedPriority == title {
            sender.backgroundColor = .clear
            selectedPriority = ""
            
        }else{
            selectedPriority = title
            
            switch title{
            case "Low":
                lowPriorityButton.backgroundColor = Constant.midGreen
                mediumPriorityButton.backgroundColor = .clear
                highPriorityButton.backgroundColor = .clear
                
            case "Medium":
                mediumPriorityButton.backgroundColor = Constant.mandysPink
                lowPriorityButton.backgroundColor = .clear
                highPriorityButton.backgroundColor = .clear
                
            case "High":
                highPriorityButton.backgroundColor = Constant.midRed
                mediumPriorityButton.backgroundColor = .clear
                lowPriorityButton.backgroundColor = .clear
                
            default:
//                fatalError("UnKnown Title for Priority Buttons")
                return
            }
            
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let taskName = taskNameTextField.text, taskName != "", let taskDescritpion = taskDescritpitonTextField.text, taskDescritpion != ""{
            if selectedPriority != ""{
                if let date = dateTextField.text, date != "", let time = alarmTextField.text, time != ""{
                    if let selectedCategory = selectedCategory.category {
                        // MARK: Save New Task
                        let task = Task(context: CoreDataManager.shared.context)
                        task.name = taskName
                        task.descritpion = taskDescritpion
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM yyyy h:mm a"
                        
                        task.date = formatter.date(from: "\(date) \(time)")
                        
                        task.priority = selectedPriority
                        
                        task.parentCategory = selectedCategory
                        
                        task.isDone = false
                        
                        self.tasks.append(task)
                        
                        if CoreDataManager.shared.saveData() {
                            // Saved Successfully
                            tabBarController?.selectedIndex = 0
                            
                        }else{
                            showErrorAlert(title: "Saving New Task", message: "There is error while saving new task. please try again later")
                        }
                        
                    }else{
                        showErrorAlert(title: "Category", message: "Please select category")
                        return
                    }
                }else{
                    showErrorAlert(title: "Date & Alarm", message: "Please select date & alarm time")
                    return
                }
            }else{
                showErrorAlert(title: "Prioriry", message: "Please select task priority")
                return
            }
        }else{
            showErrorAlert(title: "Task", message: "Please add task name & task descritption")
            return
        }
        
    }
    
    private func showErrorAlert(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TextField Delegate
extension CreateTaskVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == taskNameTextField{
            taskDescritpitonTextField.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        
        return true
    }
}


// MARK: - CollectionView DataSource
extension CreateTaskVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categories.isEmpty {
            return 1
        }
        
        return categories.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateTaskCollectionViewCell.identifier, for: indexPath) as! CreateTaskCollectionViewCell
        
        if categories.isEmpty {
            cell.categoryNameLabel.text = "You need to create Category"
            return cell
        }
        
        cell.configure(category: categories[indexPath.row])
        
        return cell
    }
}


// MARK: - CollectionView Delegate
extension CreateTaskVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if categories.isEmpty{
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CreateTaskCollectionViewCell
        
        if cell.category == selectedCategory.category && selectedCategory.isSelected{
            // There is selected category then do ->
            selectedCategory.category = nil
            selectedCategory.isSelected = false
            cell.categoryView.layer.borderColor = UIColor.clear.cgColor
            
        }else if !selectedCategory.isSelected{
            // No selected category then do ->
            selectedCategory.isSelected = true
            selectedCategory.category = cell.category
            cell.categoryView.layer.borderWidth = 3
            cell.categoryView.layer.borderColor = Constant.black?.cgColor
        }
    }
}


// MARK: - CollectionView Flow Layout
extension CreateTaskVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.3, height: collectionView.frame.height * 0.8)
    }
}
