//
//  Enumerations.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import Foundation

enum Year {
    case current
    case previous(Int)
    
    func description() -> String {
        switch self {
        case .current:
            return "current"
        case .previous(let value):
            return String(value)
        }
    }
}

enum ResultType {
    case race([Race])
    case result([Results])
}

enum State {
    case notSearchedYet
    case loading
    case noResult
    case results(ResultType)
}
