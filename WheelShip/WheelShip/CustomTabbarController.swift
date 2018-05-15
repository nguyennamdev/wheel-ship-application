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
        
        // init first tabbar item
        let homeOrdererController = HomeOrdererController()
        homeOrdererController.user = createDummyUser()
        let navigationHomeOrderer = setupTabbarItem(item: homeOrdererController, title: "Trang chủ", image: #imageLiteral(resourceName: "homepage"))
        
        // init second tabbar item
        let historyViewController = HistoryViewController()
        historyViewController.user = createDummyUser()
        let navigationHistoryVC = setupTabbarItem(item: historyViewController, title: "Lịch sử", image: #imageLiteral(resourceName: "folder"))
        
        // init third tabbar item
        let userViewController = UserViewController()
        userViewController.user = createDummyUser()
        let navigationUserVC = setupTabbarItem(item: userViewController, title: "Cá nhân", image: #imageLiteral(resourceName: "user"))
        
        viewControllers = [ navigationHomeOrderer,
                            navigationHistoryVC,
                            navigationUserVC ]
        self.tabBar.tintColor = UIColor.black
        // if user is not logged in
//        if isLoggedIn() {
//            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
//        }
    }

    private func setupTabbarItem(item:UIViewController, title:String, image:UIImage) -> UINavigationController {
        item.tabBarItem.title = title
        item.tabBarItem.image = image
        let navigation = UINavigationController(rootViewController: item)
        return navigation
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
        user.uid = "test0001";
        user.name = "nguyen nam";
        user.phoneNumber = "016231231231";
        user.email = "nguyennam26897@gmail.com"
        user.isShipper = TypeOfUser.isOrderer;
        return user;
    }
}
