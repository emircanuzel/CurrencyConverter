//
//  Exchange.swift
//  CurrencyConverter
//
//  Created by emircan.uzel on 9.09.2022.
//

import Foundation
import Alamofire

extension ApiManager
{
    func getExchange(fromAmount: String, fromCurrency: String, toCurrency: String, completion: @escaping (NetworkResponse<ResponseExchange>) -> ()) {
        let params = fromAmount + "-" + fromCurrency + "/" + toCurrency + "/latest"
        guard let url = URL(string: Endpoint.baseURL.rawValue + params) else { return}
        AF.request(url,method:.get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    do {
                        guard let data = response.data else { return  }
                        let result = try decoder.decode(ResponseExchange.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.error(.init( message: error.localizedDescription)))
                    }
                case .failure(let error):
                    completion(.error(.init( message: error.localizedDescription)))
                }
            }
    }
}

struct ResponseExchange: Codable
{
    var amount: String?
    var currency: String?
}
