//
//  CustomTabbarController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/29/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class CustomTabbarController: UITabBarController {
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.tabBar.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
   // MARK: Call apis
    private func getNumberOfNotificationForOrderer(ordererId:String, response:@escaping (Int) -> Void){
        getNumberNotification(urlString: "\(Define.URL)/orders/orderer/count_order_wait_response", with: ordererId, or: nil, response: response)
    }
    
    private func getNumberOfNotificationForShipper(shipperId:String, response:@escaping (Int) -> Void){
        getNumberNotification(urlString: "\(Define.URL)/orders/shipper/count_order_responsed", with: nil, or: shipperId, response: response)
    }
    
    private func getNumberNotification(urlString: String, with ordererId:String?,or shipperId:String?, response: @escaping (Int) -> Void){
        var paremeters:[String: Any] = [String: Any]()
        if ordererId != nil {
            paremeters = ["userId": ordererId!]
        }else if shipperId != nil{
            paremeters = ["shipperId": shipperId!]
        }
        Alamofire.request(urlString, method: .get, parameters: paremeters, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? NSDictionary{
                if let resultData = value.value(forKey: "data") as? [[String: Any]]{
                    if let firstData = resultData.first{
                        if let numberOfNotifications = firstData["size"] as? Int {
                            response(numberOfNotifications)
                        }
                    }
                }
            }
        }
    }
    
    
    public func loadViewControllersForOrderer(user:User){
        // init first tabbar item
        let homeOrdererController = HomeOrdererController()
        homeOrdererController.user = user

        // init second tabbar item
        let ordererHistoryViewController = OrdererHistoryViewController()
        ordererHistoryViewController.user = user
        
        // init third tabbar item
        let ordererNotificationViewController = OrdererNotificationViewController()
        ordererNotificationViewController.user = user
        
        // forth tabbar item
        let userViewController = UserViewController()
        userViewController.user = user
        
        // set view controllers for tabbar
        self.viewControllers = [ setupTabbarItem(item: homeOrdererController, title: "Trang chủ", image: #imageLiteral(resourceName: "home_tabbar")),
                            setupTabbarItem(item: ordererHistoryViewController, title: "Lịch sử", image: #imageLiteral(resourceName: "folder_tabbar")),
                            setupTabbarItem(item: ordererNotificationViewController, title: "Thông báo", image: #imageLiteral(resourceName: "notification")),
                            setupTabbarItem(item: userViewController, title: "Cá nhân", image: #imageLiteral(resourceName: "user_tabbar")) ]
        
        // get number of notifications
        getNumberOfNotificationForOrderer(ordererId: user.uid!) { (numberOrNotification) in
            let number = numberOrNotification
            if number == 0 {
                ordererNotificationViewController.tabBarItem.badgeValue = nil
            }else{
                ordererNotificationViewController.tabBarItem.badgeValue = "\(numberOrNotification)"
            }
        }
        
    }
    
    public func loadViewControllersForShipper(user:User){
        
        // first tabbar item
        let homeShipperController = HomeShipperViewController()
        homeShipperController.user = user
        
        // second tabbar item
        let shipHistoryViewController = ShipHistoryViewController()
        shipHistoryViewController.user = user
        
        // third tabbar item
        let shipperNotificationViewController = ShipperNotificationViewController()
        shipperNotificationViewController.user = self.user
        
        // fourth tabbar item
        let userViewController = UserViewController()
        userViewController.user = user
        
        
        // set view controllers for tabbar
        self.viewControllers = [ setupTabbarItem(item: homeShipperController, title: "Đơn hàng", image: #imageLiteral(resourceName: "home_tabbar")),
                                 setupTabbarItem(item: shipHistoryViewController, title: "Thư viện", image: #imageLiteral(resourceName: "folder_tabbar")),
                                 setupTabbarItem(item: shipperNotificationViewController, title: "Thông báo", image: #imageLiteral(resourceName: "notification")),
                                 setupTabbarItem(item: userViewController, title: "Cá nhân", image: #imageLiteral(resourceName: "user_tabbar"))]
        
        // get number of notifications
        getNumberOfNotificationForShipper(shipperId: user.uid!) { (numberOfNotification) in
            let numberSaved = UserDefaults.standard.getNumberOfNotification()
            if numberOfNotification > numberSaved{
                let numberWillShow = numberOfNotification - numberSaved // get number will show when minus 2 number these
                shipperNotificationViewController.tabBarItem.badgeValue = "\(numberWillShow)"
            }else{
                shipperNotificationViewController.tabBarItem.badgeValue = nil
            }
            UserDefaults.standard.setNumberOfNotifitcationForShipper(number: numberOfNotification)
        }
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
