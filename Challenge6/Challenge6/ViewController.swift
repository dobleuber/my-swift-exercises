//
//  ViewController.swift
//  Challenge6
//
//  Created by Wbert Castro on 16/07/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countriesUrl = "https://restcountries.eu/rest/v2/all"
        if let url = URL(string: countriesUrl) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                
                for countryData in json.array! {
                    countries.append(Country(countryData: countryData))
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController {
            vc.country = countries[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath) as! CountryCell
        
        let country = countries[indexPath.item]
        
        cell.countryName.text = country.name
        
        let imageFlag = UIImage(named: "\(country.code.lowercased()).png") ?? 
            UIImage(named: "image-not-available.png")
        cell.imageFlag.image = imageFlag
        
        return cell
    }
}

