//
//  Int+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import Foundation

extension Int {
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

    func getPlayTime() -> String {
        let (h, m, s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        if h > 0 {
            return String(format: "%02d", h) + ":" + String(format: "%02d", m) + ":" + String(format: "%02d", s)
        } else {
            return String(format: "%02d", m) + ":" + String(format: "%02d", s)
        }
    }

    /// (n == 0) -> 00, (n < 10) -> 0n , (10 > n) -> n
    var timeString: String {
        let absInt = abs(self)
        switch absInt {
        case 0:
            return "00"
        case 1 ..< 10:
            return "0\(absInt)"
        default:
            return "\(absInt)"
        }
    }
}
