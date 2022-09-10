//
//  ViewExtension.swift
//  CurrencyConverter
//
//  Created by emircan.uzel on 8.09.2022.
//

import Foundation
import UIKit

extension UIView
{
    func setCornerRadius(radius:Int)
    {
        self.layer.cornerRadius = CGFloat(radius);
        self.layer.masksToBounds = true;
    }
    
    func setBorder(width: CGFloat, color: UIColor? = nil)
    {
        self.layer.borderWidth = width
        if let borderColor = color?.cgColor {
            self.layer.borderColor = borderColor
        }
    }
}
