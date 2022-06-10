//
//  ReuseIdentifiable.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import UIKit

protocol ReuseIdentifiable {
    static func reuseIdentifier() -> String
}

extension ReuseIdentifiable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}
extension UICollectionViewCell: ReuseIdentifiable {}
extension UICollectionReusableView: ReuseIdentifiable {}
