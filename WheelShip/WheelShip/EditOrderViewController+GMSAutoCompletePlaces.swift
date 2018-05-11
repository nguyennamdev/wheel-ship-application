//
//  EditOrderViewController+GMSAutoCompletePlaces.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire


// MARK: implement functions of GMSAutocompleteViewControllerDelegate
extension EditOrderViewController : GMSAutocompleteViewControllerDelegate {
    
    // Handle the distance address
    func handleDistanceAddress(originLocation:CLLocation, destinationLocation:CLLocation){
        if let path = Bundle.main.path(forResource: "GoogleService", ofType: "plist"){
            let dict = NSDictionary(contentsOfFile: path)
            let distanceMatrixApiKey = dict?.value(forKey: "Matrix API key") as! String
            
            // valid location
            let origins = "\(originLocation.coordinate.latitude),\(originLocation.coordinate.longitude)"
            let destinations = "\(destinationLocation.coordinate.latitude),\(destinationLocation.coordinate.longitude)"
            
            Alamofire.request("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(origins)&destinations=\(destinations)&key=\(distanceMatrixApiKey)").responseJSON { (response) in
                if let json = response.result.value {
                    // return tupple distance text and distance value
                    let result = self.parseDistanceJson(json: json)
                    let distanceText = result.text
                    let distanceValue = result.value
                    guard let priceDistance = self.order.unitPrice?.priceOfDistance?.value else { return }
                    self.order.unitPrice?.feeShip = Double(priceDistance * (distanceValue / 1000))
                    self.order.distance = distanceValue
                    if let feeShip = self.order.unitPrice?.feeShip {
                        self.distanceLabel.setAttitudeString(title: ("\t Khoảng cách: ", UIColor.gray), content: (distanceText + " = \(feeShip.formatedNumberWithUnderDots()) vnđ", UIColor.black, UIFont.boldSystemFont(ofSize: 13)))
                        self.updateOverheadsLabel()
                    }
                }
            }
        }
    }
    
    private func parseDistanceJson(json:Any) -> (text:String, value:Double){
        var result:String?
        var distanceValue:Double?
        if let jsonData = json as? [String: Any] {
            if let rows = jsonData["rows"] as? [[String : Any]]{
                if let element = rows.first!["elements"] as? [[String : Any]] {
                    if let distance = element.first!["distance"] as? [String : Any] {
                        let text = distance["text"] as! String
                        result = text
                        let value = distance["value"] as! Double
                        distanceValue = value
                    }
                    if let duration = element.first!["duration"] as? [String : Any] {
                        let text = duration["text"]  as! String
                        result?.append(" - \(text)")
                    }
                }
            }
        }
        return (result!, distanceValue!)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let address = place.formattedAddress else { return }
        let location = CLLocation(latitude:place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        // take address and locations to textfields
        if currentTextFieldIsShowing == originAddressTextField.tag {
            self.originAddressTextField.text = address
            self.order.originLocation = location
        }else if currentTextFieldIsShowing == destinationAddressTextField.tag {
            destinationAddressTextField.text = address
            self.order.destinationLocation = location
        }
        dismiss(animated: true, completion: nil)
        self.updateStateBarButton()
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
