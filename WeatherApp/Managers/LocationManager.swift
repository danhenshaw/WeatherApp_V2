//
//  LocationManager.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 19/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import CoreLocation

enum locationAuthorisationStatus {
    case authorizedAlways, authorizedWhenInUse, denied, notDetermined, restricted
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    func requestLocation(completion: @escaping (_ cityData: CityDataModel?, _ error: Error?) -> Void ) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            
            locationManager.startUpdatingLocation()

            while locationManager.location?.coordinate.latitude == nil {}
            
            if locationManager.location?.coordinate.latitude != nil && locationManager.location?.coordinate.longitude != nil {
                
                locationManager.stopUpdatingLocation()

                let latitude = (locationManager.location?.coordinate.latitude)!
                let longitude = (locationManager.location?.coordinate.longitude)!
                let cityData = CityDataModel()
                cityData.latitude = latitude
                cityData.longitude = longitude
                cityData.cityName = ""
                completion(cityData, nil)
            }
        }

    }
    
    func locationServicesStatus() -> locationAuthorisationStatus {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways : return .authorizedAlways
        case .authorizedWhenInUse : return .authorizedWhenInUse
        case .denied : return .denied
        case .notDetermined : return .notDetermined
        case .restricted : return .restricted
        }
    }
    
    
    func requestCityName(latitude: Double, longitude: Double, completion: @escaping (_ cityName: String?, _ error: Error?) -> Void ) {
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let error = error { return completion(nil, error) }
            if let placemark = placemarks?[0] { return completion(placemark.locality ?? "City name unavailable", nil) }
        })
    }
}
