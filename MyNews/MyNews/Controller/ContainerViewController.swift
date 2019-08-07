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
    
    var homeController: HomeViewController!
    var menuController: MenuViewController!
    var centerController: UIViewController!
    var isExpended = false
    let requestsManager = RequestsManager()
    var city: String?
    var sources: JSON?
    var userSources: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.requestsManager.getSources(completationHandler: {(response) in
            guard response?.isEmpty == false else { return }
            self.sources = response
        })
        configureHomeController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestsManager.currentCity(completationHandler: {(response) in
            if let city = response {
                self.city = city
            }
        })
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
        homeController = HomeViewController()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "weathrSegue" && sender != nil) {
            if let evc = segue.destination as? WeatherViewController {
                evc.city = self.city
                evc.json = sender as? JSON
            }
        }
        if (segue.identifier == "sourcesSegue" && sender != nil) {
            if let evc = segue.destination as? SourcesViewController {
                if sources!.isEmpty {
                    evc.userSources = []
                } else {
                    let str = sender as! String
                    let subUserSources = str.split(separator: ",")
                    var usrSources: [String] = []
                    for sub in subUserSources {
                        usrSources.append(String(sub))
                    }
                    evc.userSources = usrSources
                }
                evc.json = sources
            }
        }
        if (segue.identifier == "newsSegue" && sender != nil) {
            if let evc = segue.destination as? NewsViewController {
                evc.data = (sender as? ([JSON], Int))?.0
                evc.index = (sender as? ([JSON], Int))?.1
            }
        }
    }
    
    func didSelectMenuOption(menuOption: MenuOptions) {
        switch menuOption {

        case .Sources:
            requestsManager.getUserSources(completationHandler: {(response) in
                if response != nil {
                    DispatchQueue.main.async {
                        print("========>", response!)
                        self.performSegue(withIdentifier: "sourcesSegue", sender: response)
                    }
                }
            })
        case .Weather:
            self.requestsManager.getWeatherJSON(forCity: city!, completationHandler: {(response) in
                guard response?.isEmpty == false else { return }
                self.performSegue(withIdentifier: "weathrSegue", sender: response)
            })
        case .Profile:
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
    func handleMenuToggle(menuOption: MenuOptions?, newsData: ([JSON], Int)?) {
        if newsData == nil {
            if !isExpended {
                configureMenuController()
            }
            isExpended = !isExpended
            animateMenu(shouldExpand: isExpended, menuOption: menuOption)
        } else {
            performSegue(withIdentifier: "newsSegue", sender: newsData)
        }
    }
}
