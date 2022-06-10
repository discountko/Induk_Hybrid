//
//  Optional+.swift
//  ExchangeRate
//
//  Created by pineone on 2022/04/18.
//

import Foundation

extension Optional where Wrapped == String {
    func unwrap(_ placeHolder: String = .empty) -> Wrapped {
        guard let self = self else { return placeHolder }
        return self
    }
}
