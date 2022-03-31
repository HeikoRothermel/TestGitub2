//
//  ViewController.swift
//  TestGitub2
//
//  Created by Heiko Rothermel on 3/31/22.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet var table: UITableView!
    
    var models = [Weather]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Register 2 cells
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        
    }
    
    
    // Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

}

struct Weather {
    
}

