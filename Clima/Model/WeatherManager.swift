//
//  WeatherManager.swift
//  Clima
//
//  Created by Salah Khaled on 3/2/20.
//  Copyright © 2020 Salah Khaled. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f5a8fd7371e655c9a174a7479fea4230&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func featchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(x: urlString)
    }
    func featchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(x: urlString)
    }
    
    func performRequest(x urlSting: String) {
        
        if let url = URL(string: urlSting) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeDate = data {
                    
                    if let weather = self.parseJSON(safeDate) {
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let conditionId = decodedData.weather[0].id
            
            
            return WeatherModel(cityName: cityName, temperature: temperature, conditionId: conditionId)
            
        } catch  {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
