//
//  DateFormatter.swift
//  SimpleArchi
//
//  Created by François JUTEAU on 15/05/2023.
//

import Foundation

extension String {
    var dateFromResponse: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    var formattedDescription: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy à HH:mm"
        return dateFormatter.string(from: self)
    }
}
