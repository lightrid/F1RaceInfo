//
//  Driver.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import Foundation

struct Driver: Decodable {
    var driverId: String
    var url: String
    var firstName: String
    var lastName: String
    var permanentNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case driverId
        case url
        case firstName = "givenName"
        case lastName = "familyName"
        case permanentNumber
    }
}
