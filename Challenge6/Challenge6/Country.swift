//
//  Country.swift
//  Challenge6
//
//  Created by Wbert Castro on 16/07/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit

class Country: NSObject {
    var name: String
    var flag: String
    var code: String
    var capital: String
    var region: String
    var population: Int
    var demonym: String
    
//    var timeZones: [String]
//    var borders: [String]
//    var currencies: [String]
//    var languages: [String]
    
    init(countryData: JSON) {
        name = countryData["name"].stringValue
        flag = countryData["flag"].stringValue
        code = countryData["alpha2Code"].stringValue
        capital = countryData["capital"].stringValue
        region = countryData["region"].stringValue
        population = countryData["population"].intValue
        demonym = countryData["demonym"].stringValue
    }
}
