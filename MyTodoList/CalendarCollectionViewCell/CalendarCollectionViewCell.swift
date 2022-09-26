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
    
    public func configure(dayTitle: String, dayNumber: String){
        self.dayTitleLabel.text = dayTitle
        self.dayNumberLabel.text = dayNumber
    }
}
