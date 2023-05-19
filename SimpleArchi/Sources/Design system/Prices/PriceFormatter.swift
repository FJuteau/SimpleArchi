//
//  PriceFormatter.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 18/05/2023.
//

import Foundation

final class PriceFormatter {
    static func formatToPrice(from priceDouble: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        let number = NSNumber(value: priceDouble)
        guard let formattedValue = formatter.string(from: number) else {
            return "\(priceDouble) €"
        }
        return "\(formattedValue) €"
    }
}
