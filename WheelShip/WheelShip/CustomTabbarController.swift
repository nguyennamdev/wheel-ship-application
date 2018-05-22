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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
//        self.tabBar.tintColor = UIColor.black

        // if user is not logged in
        if isLoggedIn() == false{
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }else{
            self.user = UserDefaults.standard.getUser()
       
            if self.user?.userType == TypeOfUser.isOrderer {
                loadViewControllersForOrderer(user: self.user!)
            }else{
                loadViewControllersForShipper(user: self.user!)
            }
        }
    }
    
    public func loadViewControllersForOrderer(user:User){
        
        // init first tabbar item
        let homeOrdererController = HomeOrdererController()
        homeOrdererController.user = user
        let navigationHomeOrderer = setupTabbarItem(item: homeOrdererController, title: "Trang chủ", image: #imageLiteral(resourceName: "home_tabbar"))
        
        // init second tabbar item
        let historyViewController = HistoryViewController()
        historyViewController.user = user
        let navigationHistoryVC = setupTabbarItem(item: historyViewController, title: "Lịch sử", image: #imageLiteral(resourceName: "folder_tabbar"))
        
        let userViewController = UserViewController()
        userViewController.user = user
        let navigationUserVC = setupTabbarItem(item: userViewController, title: "Cá nhân", image: #imageLiteral(resourceName: "user_tabbar"))
        
        // set view controllers for tabbar
        self.viewControllers = [ navigationHomeOrderer,
                            navigationHistoryVC,
                            navigationUserVC ]
    }
    
    public func loadViewControllersForShipper(user:User){
        
        // first tabbar item
        let homeShipperController = HomeShipperViewController()
        homeShipperController.user = user
        let navigationHomeShipper = setupTabbarItem(item: homeShipperController, title: "Đơn hàng", image: #imageLiteral(resourceName: "home_tabbar"))
        
        // second tabbar item
        let shipHistoryViewController = ShipHistoryViewController()
        shipHistoryViewController.user = user
        let navigationLibraryVC = setupTabbarItem(item: shipHistoryViewController, title: "Thư viện", image: #imageLiteral(resourceName: "folder_tabbar"))
        
        let userViewController = UserViewController()
        userViewController.user = user
        let navigationUserVC = setupTabbarItem(item: userViewController, title: "Cá nhân", image: #imageLiteral(resourceName: "user_tabbar"))
        
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
    
    @objc public func showLoginController(){
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
}
