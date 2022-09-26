//
//  CustomTabBarController.swift
//  MyTodoList
//
//  Created by Khater on 9/22/22.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tabBar.items?[1].isEnabled = false
        
        setupMiddleButton()
    }
    
    private func setupMiddleButton(){
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)  - 25, y: -20, width: 60, height: 60))
        
        middleButton.setBackgroundImage(UIImage(named: Constant.plusButton), for: .normal)
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        
        middleButton.addTarget(self, action: #selector(plusButtonPressed(_:)), for: .touchUpInside)
        
        self.tabBar.addSubview(middleButton)
        
//        self.view.layoutIfNeeded()
    }
    
    @objc func plusButtonPressed(_ sender: UIButton){
        self.selectedIndex = 1
    }
}


// MARK: - Delegate
extension CustomTabBarController{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

            guard let fromView = selectedViewController?.view, let toView = viewController.view else {
              return false // Make sure you want this as false
            }

            if fromView != toView {
              UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
            }

            return true
        }
}
