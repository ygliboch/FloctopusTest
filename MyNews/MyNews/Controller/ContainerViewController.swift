//
//  ContainerViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/1/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase

class ContainerViewController: UIViewController {

    var menuController: MenuViewController!
    var centerController: UIViewController!
    var isExpended = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureHomeController() 
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpended
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
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func animateMenu(shouldExpand: Bool, menuOption: MenuOptions?) {
        switch shouldExpand {
        case true:
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 250
            }, completion: nil)
        case false:
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else {return}
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        animatedStatusBar()
    }
    
    func animatedStatusBar() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func didSelectMenuOption(menuOption: MenuOptions) {
        switch menuOption {
//        case .News:
//            let controller = NewsViewController()
//            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Sources:
            performSegue(withIdentifier: "sourcesSegue", sender: "Foo")
//            let controller = SourcesViewController()
//            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Weather:
            performSegue(withIdentifier: "weathrSegue", sender: "Foo")
//            let controller = WeatherViewController()
//            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Profile:
//            let controller = ProfileViewController()
//            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            performSegue(withIdentifier: "profileSegue", sender: "Foo")
        case .Exit:
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            performSegue(withIdentifier: "LogOutSegue", sender: "Foo")
        }
    }
    
}

extension ContainerViewController: HomeControllerDelegete {
    func handleMenuToggle(menuOption: MenuOptions?) {
        if !isExpended {
            configureMenuController()
        }
        isExpended = !isExpended
        animateMenu(shouldExpand: isExpended, menuOption: menuOption)
    }
}
