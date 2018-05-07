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
                            setupHistoryViewController()]
        self.tabBar.tintColor = UIColor.black
        // if user is not logged in
//        if isLoggedIn() {
//            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
//        }
    }
    
    // MARK : - private functions
    private func setupHomeController() -> UINavigationController{
        let homeOrdererController = HomeOrdererController()
        homeOrdererController.tabBarItem.title = "Trang chủ"
        homeOrdererController.tabBarItem.image = #imageLiteral(resourceName: "wheel")
        homeOrdererController.user = createDummyUser();
        let navigationHome = UINavigationController(rootViewController: homeOrdererController)
        return navigationHome
    }
    
    private func setupHistoryViewController() -> UINavigationController{
        let historyViewController = HistoryViewController()
        historyViewController.tabBarItem.title = "Lịch sử"
        historyViewController.tabBarItem.image = #imageLiteral(resourceName: "wheel")
        historyViewController.user = createDummyUser();
        let navigationHome = UINavigationController(rootViewController: historyViewController)
        return navigationHome
    }
    

    
    private func isLoggedIn() -> Bool{
        return UserDefaults.standard.getIsLoggedIn()
    }
    
    @objc private func showLoginController(){
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    
    private func createDummyUser() -> User{
        let user = User()
        user.uid = "id000001";
        user.name = "nguyen nam";
        user.phoneNumber = "016231231231";
        user.isShipper = TypeOfUser.isOrderer;
        return user;
    }
}
