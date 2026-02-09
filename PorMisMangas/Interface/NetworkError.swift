//
//  NetworkError.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 11/02/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case general(Error)
    case status(Int)
    case json(Error)
    case dataNotValid
    case nonHTTP
    
    var errorDescription: String? {
        switch self {
        case .general(let error):
            error.localizedDescription
        case .status(let int):
            "HTTP status code: \(int)"
        case .json(let error):
            "JSON error: \(error)"
        case .dataNotValid:
            "Invalid data received from server"
        case .nonHTTP:
            "URLSession did not return a HTTP URL Response"
        }
    }
}
