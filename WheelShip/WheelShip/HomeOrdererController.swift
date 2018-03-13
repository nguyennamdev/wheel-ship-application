//
//  HomeOrdererController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class HomeOrdererController:UIViewController {
    
    // MARK: Properties
    var locationManager:CLLocationManager?
    var fromLocation:CLLocation?{
        didSet{
            if !userChangedFromAddress{
                convertLocationToAddress(location: fromLocation) { (address) in
                    self.fromAddressTextField.text = address
                }
            }
        }
    }
    var toLocation:CLLocation?{
        didSet{
            print("\(toLocation)")
        }
    }
    var bottomConstantOfDescriptionTextField:NSLayoutConstraint?
    var mapChangedFromUserInteraction = false
    var autocompleteViewController:GMSAutocompleteViewController?
    var numberOfTextFieldDidBeginEditing:Int?
    var userChangedFromAddress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Thêm đơn mới"
        view.addSubview(background)
        background.frame = view.frame
        
        // setup views
        setupPageControl()
        setupGoogleMapsView()
        setupFromAddressTextField()
        setupToAddressTextField()
        
        navigationItem.rightBarButtonItem = righBarButtonItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endingEntryText))
        view.addGestureRecognizer(tapGesture)
        
        textFieldSetDelegate()
        setupCLLocationManager()
        
        // google apis delegate
        mapsView.delegate = self
        autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem(title: "Trở lại", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: Private functions
    private func updateStateDoneBarButton(){
        guard let fromAddress = fromAddressTextField.text ,
            let toAddress = toAddressTextField.text else { return }
        switch ""{
        case fromAddress, toAddress:
            righBarButtonItem.isEnabled = false
        default:
            righBarButtonItem.isEnabled = true
        }
    }
    
    private func textFieldSetDelegate(){
        fromAddressTextField.delegate = self
        toAddressTextField.delegate = self
    }
    
    private func setupCLLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        DispatchQueue.main.async {
            self.locationManager?.startUpdatingLocation()
        }
    }
    // MARK: Views
    let background:GradientView = {
        let gv = GradientView()
        gv.colors = [ UIColor.rgb(r: 190, g: 147, b: 197).cgColor,
                      UIColor.rgb(r: 123, g: 198, b: 204).cgColor]
        return gv
    }()
    
    let fromAddressTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Địa chỉ bắt đầu"
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "placeholder"))
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.tag = 0
        tf.clearButtonMode = .always
        return tf
    }()
    
    let toAddressTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Địa chỉ đến"
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "placeholder2"))
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.tag = 1
        return tf
    }()
    
    let mapsView:GMSMapView = {
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(15, maxZoom: 25)
        mapView.settings.myLocationButton = true
        return mapView
    }()
    
    let pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var righBarButtonItem:UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Tiếp", style: .done, target: self, action: #selector(showOrdererEnterInfo))
        barButton.isEnabled = false
        return barButton
    }()
    
}

// MARK:  implement functions of text field delegate
extension HomeOrdererController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStateDoneBarButton()
//        self.locationManager?.startUpdatingLocation()
    }
    
    func createAMarker(location:CLLocation, title:String, snippet:String?){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title = title
        marker.snippet = snippet ?? ""
        marker.map = mapsView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            numberOfTextFieldDidBeginEditing = 0
        }else {
            numberOfTextFieldDidBeginEditing = 1
        }
        self.present(autocompleteViewController!, animated: true, completion: nil)
    }
    // alert user enter phone number don't match pattern
    func checkUserEnterPhoneNumber(text:String){
        let pattern = "^(01[2689]|09)[0-9]{8}$"
        let predicate = NSPredicate(format: "self MATCHES [c] %@", pattern)
        
        if !predicate.evaluate(with: text){
            let alertDialog = UIAlertController(title: "Sai số điện thoại", message: "Bạn đã nhập số điện thoại không đúng định dạng", preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertDialog.addAction(okAction)
            self.present(alertDialog, animated: true, completion: nil)
        }
    }
}
// MARK: implement functions of CLLocationManagerDelegate
extension HomeOrdererController : CLLocationManagerDelegate{
    
    func mapViewCameraDidChangeFromUserInteraction() -> Bool {
        let view:UIView = self.mapsView.subviews[0] as UIView
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers{
                if (recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended || recognizer.state == UIGestureRecognizerState.recognized){
                    return true
                }
            }
        }
        return false
    }
    
    func loadMyLocation(location:CLLocation){
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        DispatchQueue.main.async {
            self.mapsView.animate(to: camera)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Use Control Flow: if the user has moved the map, then don't re-center.
        // NOTE: this is using 'mapChangedFromUserInteraction' from above.
        if mapChangedFromUserInteraction == false{
            self.loadMyLocation(location: location)
            self.fromLocation = location
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            showAlertUserDeniedAccessToLocation()
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    private func showAlertUserDeniedAccessToLocation(){
        let alert = UIAlertController(title: "Quyền truy cập vị trí", message: "Bạn chưa cấp quyền truy cập vị trí của bạn", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // create setting action to access to enable location
        let settingAction = UIAlertAction(title: "Setting", style: .default) { (action) in
            guard let settingUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingUrl){
                UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        present(alert, animated: true, completion: nil)
    }
    
    func convertLocationToAddress(location:CLLocation?, complete:@escaping (String) -> ()){
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error != nil {
                print(error!)
                return
            }
            // get result
            var result = ""
            guard let placeMark = placeMarks?.first else { return }
            if let name = placeMark.name {
                result += "\(name), "
            }
            // street address
            if let thouroughfare = placeMark.thoroughfare{
                result += "\(thouroughfare), "
            }
            // city
            if let locality = placeMark.locality {
                result += "\(locality), "
            }
            // country
            if let country = placeMark.country{
                result += "\(country)"
            }
            complete(result)
        }
    }

}

// MARK: implement functions of GMSMapViewDelegate
extension HomeOrdererController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // set mapChangedFromUserInteraction when user will move
        mapChangedFromUserInteraction = mapViewCameraDidChangeFromUserInteraction()
    }
}
// MARK: implement functions of GMSAutocompleteViewControllerDelegate
extension HomeOrdererController : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let address = place.formattedAddress else { return }
        let location = CLLocation(latitude:place.coordinate.latitude, longitude: place.coordinate.longitude)
       // take address into textfields and locations
        if numberOfTextFieldDidBeginEditing == 0 {
            self.fromAddressTextField.text = address
            self.userChangedFromAddress = true
            self.fromLocation = location
        }else {
            toAddressTextField.text = address
            // set mapChanged for map can't move to current location
            mapChangedFromUserInteraction = true
            // animate to location selected
            let camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 15)
            mapsView.animate(to: camera)
            // make marker that location
            createAMarker(location: location, title: place.name, snippet: place.formattedAddress)
            // assign toLocation to set value
            self.toLocation = location
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}














