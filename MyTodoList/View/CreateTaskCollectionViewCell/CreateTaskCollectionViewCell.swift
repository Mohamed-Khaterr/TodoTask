//
//  CreateTaskCollectionViewCell.swift
//  MyTodoList
//
//  Created by Khater on 9/19/22.
//

import UIKit

class CreateTaskCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var category: Category?
    
    static let identifier = "CreateTaskCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryView.cornerRadius(with: 10)
    }
    
    public func configure(category: Category){
        self.category = category
        categoryNameLabel.text = category.name
        categoryNameLabel.textColor = UIColor(named: category.color!)?.adjust(hueBy: 0, saturationBy: 0.8, brightnessBy: 0.2)
        categoryView.backgroundColor = UIColor(named: category.color!)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CreateTaskCollectionViewCell", bundle: nil)
    }

}
