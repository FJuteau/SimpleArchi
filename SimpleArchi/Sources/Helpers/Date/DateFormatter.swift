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
        dateFormatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ssZ"
        return dateFormatter.date(from: "01/16/2023")
    }
}
