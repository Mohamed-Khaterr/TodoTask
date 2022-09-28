//
//  CateoryCollectionViewCell.swift
//  MyTodoList
//
//  Created by Khater on 9/27/22.
//

import UIKit


class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var category: Category?
    
    static let identifier = "CategoryCollectionViewCell"
    
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
        
        categoryView.layer.borderWidth = 3
        if category.isSelected{
            categoryView.layer.borderColor = Constant.black?.cgColor
        }else{
            categoryView.layer.borderColor = UIColor.clear.cgColor
        }
    }

}
