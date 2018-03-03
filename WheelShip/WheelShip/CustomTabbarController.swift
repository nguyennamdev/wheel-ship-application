//
//  CustomTabbarController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/29/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        viewControllers = [ setupHomeController(),
                            setupLibaryController()]
        
        // if user is not logged in
        /*
        if isLoggedIn() {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }*/
    }
    
    // MARK : - private functions
    private func setupHomeController() -> UINavigationController{
        let homeOrdererController = HomeOrdererController()
        homeOrdererController.tabBarItem.title = "Trang chủ"
        homeOrdererController.tabBarItem.image = #imageLiteral(resourceName: "wheel")
        let navigationHome = UINavigationController(rootViewController: homeOrdererController)
        return navigationHome
    }
    
    private func setupLibaryController() -> UINavigationController{
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        vc.tabBarItem.title = "Library"
        vc.tabBarItem.image = #imageLiteral(resourceName: "wheel")
        vc.title = "Library"
        let navigationHome = UINavigationController(rootViewController: vc)
        return navigationHome
    }
    
    private func isLoggedIn() -> Bool{
        return UserDefaults.standard.getIsLoggedIn()
    }
    
    @objc private func showLoginController(){
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
}
