//
//  ServiceInfoManager.swift
//  Basic
//
//  Created by pineone on 2021/09/14.
//

import Action
import Foundation
import RxCocoa
import RxSwift
import UIKit

class ServiceInfoManager {
    static let current = ServiceInfoManager()
    private let service = "1"
    private let serviceInfo = "AppName/"
    func getService() -> String {
        return service
    }
    
    func getServiceToInt() -> Int {
        return Int(service)!
    }
    
    func getVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    func getServiceInfo() -> String {
        // AppName/2.5.0
        return "\(serviceInfo)\(getVersion())"
    }
}
