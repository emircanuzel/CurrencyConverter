//
//  ApiManager.swift
//  CurrencyConverter
//
//  Created by emircan.uzel on 9.09.2022.
//

import Foundation

class ApiManager: NSObject
{
    static let shared = ApiManager()
}

enum Endpoint: String {
    case baseURL = "http://api.evp.lt/currency/commercial/exchange/"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkResponse<T> {
    case success(T)
    case failure
    case error(ErrorModel)
}

struct CustomResponse: Codable {
    
    var response :String?
    var result: String?
    var status: String?
}

struct ErrorResponseModel: Codable {
    var error: ErrorModel?
}

struct ErrorModel: Codable {
    var code: String?
    var message: String?
    var desc: String?
    var errorId: Int?
    var status: Int?
}
