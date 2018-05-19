//
//  UserViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


struct DetailUser {
    var backgroundImage:UIColor
    var image:UIImage
    var title:String
    var valueText:String
}

class UserViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    let cellId = "cellId"
    var user:User?
    
    var listDetailUser:[DetailUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = GradientView()
        view.addSubview(background)
        background.setupDefaultColor()
        background.frame = view.frame
        
        // custom navigation item
        self.navigationItem.title = "Thông tin cá nhân"
        
        // make button logout
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleLogoutUser))
        self.navigationItem.leftBarButtonItem = logoutBarButtonItem
        
        setupViews()
        detailProfileTableView.delegate = self
        detailProfileTableView.dataSource = self
        detailProfileTableView.rowHeight = 50
        detailProfileTableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = UserDefaults.standard.getUser()
        initListDetailUser()
        detailProfileTableView.reloadData()
    }
    
    // MARK: Actions
    
    @objc private func handleLogoutUser(){
        // logout on server
        Alamofire.request("https://wheel-ship.herokuapp.com/users/logout", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        // save user didn't log in
        UserDefaults.standard.setIsLoggedIn(value: false)
        self.perform(#selector(showLoginViewController), with: nil, afterDelay: 0.01)
    }
    
    @objc private func showLoginViewController(){
        //        UserDefaults.standard.setIsLoggedIn(value: true)
        let loginViewController = LoginViewController()
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    
    func setupViews(){
        view.addSubview(profileImageView)
        view.addSubview(detailProfileTableView)
        view.addSubview(nameLabel)
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.layer.cornerRadius = 100
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        detailProfileTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24).isActive = true
        detailProfileTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        detailProfileTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:12).isActive = true
        detailProfileTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-12).isActive = true
        
        setupChangePasswordButton()
    }
    
    private func setupChangePasswordButton(){
        view.addSubview(changePasswordButton)
        changePasswordButton.anchorWithWidthHeightConstant(top: detailProfileTableView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 50)
    }
    
    private func initListDetailUser(){
        guard let name = user?.name,
            let phone = user?.phoneNumber,
            let email = user?.email
            else {
                return
        }
        listDetailUser = [
            DetailUser(backgroundImage: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), image: #imageLiteral(resourceName: "user"), title: "Tên người dùng", valueText:name),
            DetailUser(backgroundImage: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), image: #imageLiteral(resourceName: "telephone"), title: "Điện thoại", valueText: phone),
            DetailUser(backgroundImage: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), image: #imageLiteral(resourceName: "placeholder"), title: "Email", valueText: email),
        ]
        
    }
    
    // MARK: Actions
    @objc private func handleChangePassword(){
        let changePasswordViewController = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
        changePasswordViewController.modalPresentationStyle = .overCurrentContext
        changePasswordViewController.user = self.user
        self.navigationController?.present(changePasswordViewController, animated: true, completion: nil)
    }
    
    
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailProfileTableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let profileImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        image.image = #imageLiteral(resourceName: "user2")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var changePasswordButton:UIButton = {
        let button = UIButton()
        button.setTitle("Đổi mật khẩu", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        return button
    }()
}

// MARK: Implement UITableViewDatasource and UITableViewDelegate
extension UserViewController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDetailUser?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserTableViewCell
        cell.detailUser = listDetailUser?[indexPath.row]
        cell.tintColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let editUserNameVC = EditUserNameViewController()
            editUserNameVC.user = self.user
            self.navigationController?.pushViewController(editUserNameVC, animated: true)
        case 1:
            let popupEntryPhoneNumber = PopupEntryPhoneNumber()
            popupEntryPhoneNumber.userToEdit = self.user
            self.navigationController?.pushViewController(popupEntryPhoneNumber, animated: true)
        default:
            break
        }
    }
    
}
