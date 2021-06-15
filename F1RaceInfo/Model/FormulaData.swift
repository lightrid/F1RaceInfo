//
//  FormulaData.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import Foundation

struct FormulaData: Decodable {
    var mrData: MRData
    
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRData: Decodable {
    var xmlns: String
    var series: String
    var url: String
    var limit: String
    var offset: String
    var total: String
    var driverTable: DriverTable?
    var raceTable: RaceTable?
    
    enum CodingKeys: String, CodingKey {
        case xmlns
        case series
        case url
        case limit
        case offset
        case total
        case driverTable = "DriverTable"
        case raceTable = "RaceTable"
    }
}

struct DriverTable: Decodable {
    var drivers: [Driver]
    
    enum CodingKeys: String, CodingKey {
        case drivers = "Drivers"
    }
}

struct RaceTable: Decodable {
    var season: String
    var position: String?
    var races: [Race]
    
    enum CodingKeys: String, CodingKey {
        case season
        case position
        case races = "Races"
        
    }
}

struct Results: Decodable {
    var position: String
    var driver: Driver
    var time: Time?
    
    enum CodingKeys: String, CodingKey {
        case position
        case driver = "Driver"
        case time = "Time"
    }
}

struct Time: Decodable {
    var time: String
    
    enum CodingKeys: String, CodingKey {
        case time
    }
}
