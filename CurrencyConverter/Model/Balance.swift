//
//  Balance.swift
//  CurrencyConverter
//
//  Created by emircan.uzel on 8.09.2022.
//

import Foundation

class Balance
{
    var balanceEUR: Double
    var balanceUSD: Double
    var balanceJPR: Double
    var convertCount: Int = 0
    
    init(balanceEUR: Double,
         balanceUSD: Double,
         balanceJPR: Double)
    {
        self.balanceEUR = balanceEUR
        self.balanceUSD = balanceUSD
        self.balanceJPR = balanceJPR
    }
    
    func getBalanceFromType(currencyType: String) -> Double
    {
        switch currencyType
        {
        case "EUR":
            return self.balanceEUR
        case "USD":
            return self.balanceUSD
        case "JPR":
            return self.balanceJPR
        default:
            return 0
        }
    }
    
    func addValueToBalance(currencyType: String, value: Double)
    {
        switch currencyType
        {
        case "EUR":
            self.balanceEUR += value
        case "USD":
            self.balanceUSD += value
        case "JPR":
            self.balanceJPR += value
        default:
            break
        }
    }
    
    func increaseConvertCount()
    {
        self.convertCount += 1
    }
}
