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
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current:
    
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
        let current = result.daily
        self.DailyWeather = current
        
            
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
        
        tempLabel.text = "12"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        locationLabel.text = "Current Location"
        summaryLabel.text = "Clear"
        
        return headerView
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}

struct WeatherResponse: Codable {
    
//
    let timezone: String
    let daily: [Daily]
    let current: 
    
    
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


