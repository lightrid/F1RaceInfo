//
//  Driver.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import Foundation

struct Drivers: Codable {
    
    var driverId: String
    var url: String
    var givenName: String
    var familyName: String
    var dateOfBirth: String
    var nationality: String
    
    init?(json: [String: Any]) {

        guard
            let driverId = json["driverId"] as? String,
            let url = json["url"] as? String,
            let familyName = json["familyName"] as? String,
            let givenName = json["givenName"] as? String,
            let dateOfBirth = json["dateOfBirth"] as? String,
            let nationality = json["nationality"] as? String
        else {
            return nil
        }

        self.driverId = driverId
        self.url = url
        self.givenName = givenName
        self.familyName = familyName
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
    }
}

struct MRData: Codable {
    
    var xmlns: String
    var series: String?
    var url: String?
    var limit: String?
    var offset: String?
    var total: String?
    var driverTable: [Drivers]
}
