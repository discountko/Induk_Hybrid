//
//  Codable+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import Foundation

extension Encodable {
    func toJson() -> String {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)!
        }
        return .empty
    }
}
