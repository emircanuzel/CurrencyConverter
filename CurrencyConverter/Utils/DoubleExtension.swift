//
//  DoubleExtension.swift
//  CurrencyConverter
//
//  Created by emircan.uzel on 9.09.2022.
//

import Foundation

extension Double
{
    func formatWithTwoDecimal() -> String
    {
        return String(format: "%.2f", self)
    }
    
    func formatWithOneDecimal() -> String
    {
        return String(format: "%.1f", self)
    }
    
    func toString() -> String
    {
        return String(self)
    }
}

extension String
{
    func toDouble() -> Double?
    {
        return Double(self)
    }
}
