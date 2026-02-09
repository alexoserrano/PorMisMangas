//
//  URLRequest.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 10/02/26.
//

import Foundation

extension URLRequest {
    static func get(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //request.setValue("Bearer lkjfñlfkjefñifñqreiofj", forHTTPHeaderField: "Authorization") Usar en caso de implementar autorización por Token
        return request
    }
    
    static func post<JSON>(url: URL, body: JSON, method: String = "POST") -> URLRequest where JSON: Codable {
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.timeoutInterval = 30
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(body)
            return request
        }
}
