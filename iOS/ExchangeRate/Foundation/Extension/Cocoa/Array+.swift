//
//  Array+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import Foundation

extension Array {
    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }

    func get(_ indexs: [Int]) -> [Element] {
        return indexs.compactMap {
            self.get($0)
        }
    }
}

extension Array {
    func gaurdGetItems(withIndex index: Int) -> [Element] {
        return (0 ..< index).compactMap {
            self.get($0)
        }
    }
}

extension Array {
    mutating func gaurdRemoveFirst() -> Element? {
        if self.count > 0 {
            return self.removeFirst()
        }

        return nil
    }
}

