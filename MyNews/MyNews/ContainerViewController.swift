//
//  ContainerViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/1/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var menuController: UIViewController!
    var centerController: UIViewController!
    var isExpended = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController() 
    }
    
    func configureHomeController () {
        let homeController = HomeViewController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController () {
        if menuController == nil {
            menuController = MenuViewController()
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func showMenu(shouldExpand: Bool) {
        switch shouldExpand {
        case true:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 300
            }, completion: nil)
        case false:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}

extension ContainerViewController: HomeControllerDelegete {
    func handleMenuToggle() {
        if !isExpended {
            configureMenuController()
        }
        isExpended = !isExpended
        showMenu(shouldExpand: isExpended)
    }
}
