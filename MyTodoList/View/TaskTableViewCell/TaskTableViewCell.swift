//
//  HomeTableViewCell.swift
//  MyTodoList
//
//  Created by Khater on 9/17/22.
//

import UIKit
import SwipeCellKit

class TaskTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    @IBOutlet weak var secondView: UIView!
    
    private let dateFormat = DateFormatter()
    
    static let identifier = "TaskTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priorityLabel.cornerRadius(with: 7)
        categoryView.cornerRadius(with: 10)
        checkBoxImageView.cornerRadius()
        
        secondView.layer.cornerRadius = 15
        secondView.layer.shadowColor = UIColor.black.cgColor
        secondView.layer.shadowOpacity = 0.1
        secondView.layer.shadowOffset = .zero
        secondView.layer.shadowRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "TaskTableViewCell", bundle: nil)
    }
    
    public func configuare(task: String, category: String, categoryColor: UIColor, date: Date, priority: Priority, isDone: Bool){
        // Task
        taskLabel.text = task
        
        // Category
        categoryLabel.text = "  " + category + "  "
        categoryLabel.textColor = categoryColor.adjust(hueBy: 0, saturationBy: 0.8, brightnessBy: 0.2)
        categoryView.backgroundColor = categoryColor
        
        // Date Label
        dateFormat.dateFormat = "MMM d, h:mm a"
        timeLabel.text = "\(dateFormat.string(from: date))"
        
        // Priority Label
        switch priority{
        case .high:
            priorityLabel.text = "High"
            priorityLabel.backgroundColor = UIColor(named: "Mid-Red")
        case .low:
            priorityLabel.text = "Low"
            priorityLabel.backgroundColor = UIColor(named: "Mid-Green")
        case .medium:
            priorityLabel.text = "Medium"
            priorityLabel.backgroundColor = UIColor(named: "Mandys Pink")
        }
        
        checkBoxChange(isDone: isDone)
    }
    
    public func checkBoxChange(isDone: Bool){
        checkBoxImageView.image = isDone ? UIImage(named: Constant.checkBox.fill) : UIImage(named: Constant.checkBox.notFill)
    }
    
    
    public func editCellView(showeNil showe: Bool){
        if showe{
            taskLabel.text = "No Tasks"
            categoryView.isHidden = true
            priorityLabel.isHidden = true
            checkBoxImageView.isHidden = true
        }else{
            categoryView.isHidden = false
            priorityLabel.isHidden = false
            checkBoxImageView.isHidden = false
        }
    }
}
