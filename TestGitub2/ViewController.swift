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
    var models = [Daily]()
    var hourlyModels = [Hourly]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current: Current?
    
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
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b") else {
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
        
        let entries = result.daily
        
        self.models.append(contentsOf: entries)
        
        let current = result.current
        self.current = current
        
        self.hourlyModels = result.hourly
        
            
        for itm in json!.daily {
            print("Value: \(json?.timezone ?? "No timezone") \n \(itm.dt), \(itm.clouds), \(itm.uvi), \(itm.pop), \(itm.wind_gust),\(itm.temp.max),\(itm.weather.first?.main ?? "")")
        }
        
            // Update user interface
        DispatchQueue.main.async {
            self.table.reloadData()
            
            self.table.tableHeaderView = self.createTableHeader()
        }
            
            
            
            
        }
        task.resume()
        
        
    }
    
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: headerView.frame.size.height / 5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height, width: view.frame.size.width - 20, height: headerView.frame.size.height / 5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height + summaryLabel.frame.size.height, width: view.frame.size.width - 20, height: headerView.frame.size.height / 2))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
        locationLabel.text = "Current Location"
        
        guard let currentWeather = self.current else {
            return UIView()
        }
        tempLabel.text = "\(currentWeather.temp)"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = self.current?.weather.first?.main
        
        return headerView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}

struct WeatherResponse: Codable {
    
//
    let timezone: String
    let daily: [Daily]
    let current: Current
    let hourly: [Hourly]
    
    
}

struct Hourly: Codable {
    var temp: Float
    struct Weather: Codable {
        let main: String
    }
    let weather: [Weather]
}





struct Current: Codable {
    let temp: Float
    struct Weather: Codable {
        let main: String
    }
    let weather: [Weather]
    
}

struct Daily: Codable {
    let dt: Int
    let clouds: Int
    let wind_gust: Float
    let pop: Float
    let uvi: Float
    struct Temp: Codable {

        let eve: Float
        let morn: Float
        let max: Float
        let min: Float

    }
    let temp: Temp
    
    struct Weather: Codable {

        let main: String

    }
    let weather: [Weather]
    
}


