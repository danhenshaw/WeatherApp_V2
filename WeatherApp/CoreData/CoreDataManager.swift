//
//  CoreDataManager.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 20/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//


import CoreData

class CoreDataManager {
    
    func getCities() -> [City] {
        
        var cities = [City]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.sortDescriptors = []
        
        do {
            if let results = try CoreDataStack.shared.context.fetch(fetchRequest) as? [City] {
                cities = results
            }
        }
            
        catch {
            print("Error while trying to fetch photos from core data.")
        }
        
        return cities
    }
    
    
    
    
    internal func getAllCityData() -> [CityDataModel] {
        var cityDataArray = [CityDataModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.sortDescriptors = []
        
        do {
            if let results = try CoreDataStack.shared.context.fetch(fetchRequest) as? [City] {
                
                for index in 0 ..< results.count {
                    let cityData = CityDataModel()
                    cityData.cityName = results[index].cityName ?? "City name unavailable"
                    cityData.latitude = results[index].latitude
                    cityData.longitude = results[index].longitude
                    cityDataArray.append(cityData)
                }
            }
        
        } catch let error as NSError {
            print(error.description)
        }
        
        return cityDataArray
    }
    
    
    
    
    internal func getSingleCityData(index: Int) -> CityDataModel {
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        let cityData = CityDataModel()
        do {
            let fetchedResults = try CoreDataStack.shared.context.fetch(fetchRequest)
            if fetchedResults.indices.contains(index) {
                let item = fetchedResults[index]
                cityData.cityName = item.cityName ?? "City Unavailable"
                cityData.latitude = item.latitude
                cityData.longitude = item.longitude
            }
            
        } catch let error as NSError {
            print(error.description)
        }
        return cityData
    }
    
    
    
}
