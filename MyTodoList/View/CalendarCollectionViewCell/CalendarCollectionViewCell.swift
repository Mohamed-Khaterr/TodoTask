//
//  CalendarCollectionViewCell.swift
//  MyTodoList
//
//  Created by Khater on 9/25/22.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    static let identifier = "CalendarCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cornerRadius(with: 15)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CalendarCollectionViewCell", bundle: nil)
    }
    
    public func configure(dayTitle: String, dayNumber: String, isSelected: Bool){
        self.dayTitleLabel.text = dayTitle
        self.dayNumberLabel.text = dayNumber
        selectCell(isSelected: isSelected)
    }
    
    public func selectCell(isSelected: Bool){
        if isSelected {
            self.backgroundColor = Constant.lightBlack
            dayTitleLabel.textColor = Constant.backgroundColor
            dayNumberLabel.textColor = Constant.backgroundColor
        }else{
            self.backgroundColor = .clear
            dayTitleLabel.textColor = Constant.black
            dayNumberLabel.textColor = Constant.black
        }
    }
}
