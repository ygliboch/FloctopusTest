//
//  ContainerViewController.swift
//  MyNews
//
//  Created by Yaroslava HLIBOCHKO on 8/1/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ContainerViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpended
    }
    
    private let viewModel = ContainerViewModel()
    private var homeController: HomeViewController!
    private var menuController: MenuViewController!
    private var centerController: UIViewController!
    private var isExpended = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViewModel()
        viewModel.isUserProfileEmpty()
        configureHomeController()
    }
    
    private func setupViewModel() {
        viewModel.userProfileIsEmpty = {
            self.performSegue(withIdentifier: "profileSegue", sender: nil)
        }
    }
    
    private func configureHomeController () {
        homeController = HomeViewController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    private func configureMenuController () {
        guard menuController == nil else { return }
        menuController = MenuViewController()
        menuController.delegate = self
        view.insertSubview(menuController.view, at: 0)
        addChild(menuController)
        menuController.didMove(toParent: self)
    }
    
    private func animateMenu(shouldExpand: Bool, menuOption: MenuOptions?) {
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
    
    private func animatedStatusBar() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newsSegue" && sender != nil) {
            if let evc = segue.destination as? NewsViewController {
                evc.data = (sender as? ([NewsArticle], Int))?.0
                evc.index = (sender as? ([NewsArticle], Int))?.1
            }
        }
    }
    
    private func didSelectMenuOption(menuOption: MenuOptions) {
        switch menuOption {
        case .Sources:
            self.performSegue(withIdentifier: "sourcesSegue", sender: nil)
        case .Profile:
            self.performSegue(withIdentifier: "profileSegue", sender: "Foo")
        case .Exit:
            do {
                try Auth.auth().signOut()
            } catch {
                return
            }
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        }
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
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
