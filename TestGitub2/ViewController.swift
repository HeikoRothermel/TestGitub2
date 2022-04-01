//
//  ViewController.swift
//  TestGitub2
//
//  Created by Heiko Rothermel on 3/31/22.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    

    @IBOutlet var table: UITableView!
    var models = [Weather]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Register 2 cells
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    // Location
    func setupLocation() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
        
    }
    
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        print("\(lat) | \(long)")
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&appid=7e5da986d80232efd714c8abf2a1db1b") else {
            return
        }
       let task = URLSession.shared.dataTask(with: url) { data, _, error in
          
            //Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            

        
        
            var json: WeatherResponse?
                    do {
                        
                        json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    }
                    catch {
                        print("error: \(error)")
                    }
                    
                    guard let result = json else {
                        return
                    }
            
            print(result.timezone)
        
        let entries = result.current.weather
        
        self.models.append(contentsOf: entries)
            
        
            // Update user interface
        DispatchQueue.main.async {
            self.table.reloadData()
        }
            
            
            
            
        }
        task.resume()
        
        
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    

}

struct WeatherResponse: Codable {
    

    let timezone: String
    let current: Current
    
    
    
}

struct Current: Codable {
    
    let temp: Float
    let weather: [Weather]
    
}

struct Weather: Codable {
    
    let main: String
    let description: String
    
}
