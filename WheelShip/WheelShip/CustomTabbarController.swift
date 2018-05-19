//
//  CustomTabbarController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/29/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController {
    
    var user:User?
    var userViewController:UserViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor.black
     
        
        // userViewController is common view controller
        self.userViewController = UserViewController()
        
        // if user is not logged in
        if isLoggedIn() == false{
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }else{
            self.user = UserDefaults.standard.getUser()
            if self.user?.userType == TypeOfUser.isOrderer {
                loadViewControllersForOrderer()
            }else{
                loadViewControllersForShipper()
            }
        }
    }
    
    public func loadViewControllersForOrderer(){
        // init first tabbar item
        let homeOrdererController = HomeOrdererController()
        let navigationHomeOrderer = setupTabbarItem(item: homeOrdererController, title: "Trang chủ", image: #imageLiteral(resourceName: "homepage"))
        
        // init second tabbar item
        let historyViewController = HistoryViewController()
        let navigationHistoryVC = setupTabbarItem(item: historyViewController, title: "Lịch sử", image: #imageLiteral(resourceName: "folder"))
        
        let navigationUserVC = setupTabbarItem(item: userViewController!, title: "Cá nhân", image: #imageLiteral(resourceName: "user"))
        
        // set view controllers for tabbar
        self.viewControllers = [ navigationHomeOrderer,
                            navigationHistoryVC,
                            navigationUserVC ]
    }
    
    public func loadViewControllersForShipper(){
        // first tabbar item
        let homeShipperController = UIViewController()
        homeShipperController.view.backgroundColor = UIColor.red
        let navigationHomeShipper = setupTabbarItem(item: homeShipperController, title: "New feeds", image: #imageLiteral(resourceName: "homepage"))
        
        // second tabbar item
        let libraryViewController = UIViewController()
        libraryViewController.view.backgroundColor = UIColor.blue
        let navigationLibraryVC = setupTabbarItem(item: libraryViewController, title: "Thư viện", image: #imageLiteral(resourceName: "folder"))
        
        let navigationUserVC = setupTabbarItem(item: userViewController!, title: "Cá nhân", image: #imageLiteral(resourceName: "user"))
        
        // set view controllers for tabbar
        self.viewControllers = [ navigationHomeShipper, navigationLibraryVC, navigationUserVC]
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
}
