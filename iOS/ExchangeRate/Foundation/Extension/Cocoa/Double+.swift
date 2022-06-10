//
//  Double+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import UIKit

extension Double {
    func toDate() -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date
    }
    
    func dateString(format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .korea
        return dateFormatter.string(from: date)
    }
}
