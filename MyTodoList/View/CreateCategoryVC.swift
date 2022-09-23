//
//  CreateCategoryVC.swift
//  MyTodoList
//
//  Created by Khater on 9/22/22.
//

import UIKit

class CreateCategoryVC: UIViewController {

    @IBOutlet weak var categoryTitleTextField: UITextField!
    @IBOutlet weak var selecetedColorView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let colors: [String] = ["Black", "Light-Black", "Light-Blue", "Mandys Pink", "Mid-Green", "Mid-Red"]
    private var categoryies: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTitleTextField.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        selecetedColorView.cornerRadius()
        
        if let fetchedCategory = CoreDataManager.shared.fetchCategories(){
            self.categoryies = fetchedCategory
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let categoryTitle = categoryTitleTextField.text, categoryTitle != "", selecetedColorView.backgroundColor != .clear{
            var color: String = ""
            if Constant.mandysPink == selecetedColorView.backgroundColor{
                color = "Mandys Pink"
            }else if Constant.black == selecetedColorView.backgroundColor{
                color = "Black"
            }else if Constant.lightBlack == selecetedColorView.backgroundColor{
                color = "Light-Black"
            }else if Constant.lightBlue == selecetedColorView.backgroundColor{
                color = "Light-Blue"
            }else if Constant.midGreen == selecetedColorView.backgroundColor{
                color = "Mid-Green"
            }else if Constant.midRed == selecetedColorView.backgroundColor{
                color = "Mid-Red"
            }
            
            let category = Category(context: CoreDataManager.shared.context)
            category.name = categoryTitle
            category.color = color
            
            categoryies.append(category)
            if CoreDataManager.shared.saveData(){
                navigationController?.popToRootViewController(animated: true)
            }else{
                let alert = UIAlertController(title: "Saving Category", message: "There is error happend while adding new category, please try it again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = UIAlertController(title: "Title & Color", message: "You need to add title and select color", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - TextField Delegate
extension CreateCategoryVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


// MARK: - CollectionView DataSource
extension CreateCategoryVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCell", for: indexPath)
        
        let colorName = colors[indexPath.row]
        
        cell.backgroundColor = UIColor(named: colorName)
        
        cell.cornerRadius()
        
        return cell
    }
}


// MARK: - CollectionView Delegate
extension CreateCategoryVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath)
        
        cell.layer.borderColor = UIColor.white.cgColor
        
        selecetedColorView.backgroundColor = cell.backgroundColor
    }
}


// MARK: - CollectionView Flow Layout
extension CreateCategoryVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.height * 0.9, height: self.collectionView.frame.height * 0.9)
    }
}
