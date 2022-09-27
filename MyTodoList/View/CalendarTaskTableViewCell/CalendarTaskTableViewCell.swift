//
//  CalendarTaskTableViewCell.swift
//  MyTodoList
//
//  Created by Khater on 9/25/22.
//

import UIKit

class CalendarTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    
    @IBOutlet weak var taskContentView: UIView!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDescritpionLabel: UILabel!
    
    
    static let identifier = "CalendarTaskTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.cornerRadius()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = Constant.black?.cgColor
        circleView.cornerRadius()
        
        taskContentView.cornerRadius(with: 15)
        taskContentView.layer.shadowOffset = .zero
        taskContentView.layer.shadowRadius = 15
        taskContentView.layer.shadowOpacity = 1
        taskContentView.layer.shadowColor = Constant.black?.cgColor
        taskContentView.layer.shouldRasterize = true
        taskContentView.layer.shadowPath = UIBezierPath(rect: taskContentView.bounds).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CalendarTaskTableViewCell", bundle: nil)
    }
    
    func configure(time: String, remainTime: String, title: String, descritpion: String){
        timeLabel.text = time
        remainTimeLabel.text = remainTime
        taskTitleLabel.text = title
        taskDescritpionLabel.text = descritpion
    }
    
    func onlyOneCell(){
        borderView.backgroundColor = Constant.backgroundColor
        circleView.backgroundColor = Constant.black
        lineView.isHidden = true
    }
    
    func firstCell(){
        borderView.backgroundColor = Constant.backgroundColor
        circleView.backgroundColor = Constant.black
        lineView.isHidden = false
    }
    
    func middleCell(){
        borderView.backgroundColor = Constant.backgroundColor
        circleView.backgroundColor = Constant.backgroundColor
        lineView.isHidden = false
    }
    
    func lastCell(){
        borderView.backgroundColor = Constant.black
        circleView.backgroundColor = Constant.black
        lineView.isHidden = true
    }
}
