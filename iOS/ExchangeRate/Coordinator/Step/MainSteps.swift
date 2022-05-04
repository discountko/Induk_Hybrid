//
//  MainSteps.swift
//  Base
//
//  Created by pineone on 2021/09/14.
//

import RxFlow

enum MainSteps: Step {
    // MARK: - App Active (Init Step)
    case initialization
    case loginCheck
    
    case moveToMain
    
    case permissionCompleted
    
    /// App Inactive
    case exitApp
    
    // common
    case moveTab(index: TabPage)
    
    // BaseFlow, FlowSugar 화면 띄우는 방법
    case dismissModal
    case popToRootVC
    case popVC
    
    // ExchangeFlow
    case popViewController
    case popModal
    
    // BoardFlow
    
    // NewsFlow
    
    // MARK: - GNB TabBar
    case exchangeRate
    case board
    case news
    
    case login
    case emailSignUp
    case findPassword
}
