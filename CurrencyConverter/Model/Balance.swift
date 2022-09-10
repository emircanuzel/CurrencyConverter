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
    var balanceJPY: Double
    var convertCount: Int = 0
    
    init(balanceEUR: Double,
         balanceUSD: Double,
         balanceJPY: Double)
    {
        self.balanceEUR = balanceEUR
        self.balanceUSD = balanceUSD
        self.balanceJPY = balanceJPY
    }
    
    func getBalanceFromType(currencyType: String) -> Double
    {
        switch currencyType
        {
        case "EUR":
            return self.balanceEUR
        case "USD":
            return self.balanceUSD
        case "JPY":
            return self.balanceJPY
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
        case "JPY":
            self.balanceJPY += value
        default:
            break
        }
    }
    
    func increaseConvertCount()
    {
        self.convertCount += 1
    }
}
