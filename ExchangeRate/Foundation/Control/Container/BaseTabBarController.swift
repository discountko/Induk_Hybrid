//
//  BaseTabBarController.swift
//  Basic
//
//  Created by pineone on 2021/08/04.
//

import RxCocoa
import RxFlow
import RxSwift
import SnapKit
import UIKit

enum TabPage: Int {
    case one
    case two
    case three
    case four
    case five
}

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {
    static let shared = BaseTabBarController()
    
    private var _tabBarHeight: CGFloat = 0
    
    var tabBarHeight: CGFloat {
        get {
            return _tabBarHeight
        }
    }

    var isHidden: Bool {
        return self.tabBar.isHidden
    }
    
    var isEnabled = true {
        didSet {
            if let items = self.tabBar.items {
                items.forEach { $0.isEnabled = isEnabled }
            }
        }
    }
    
    lazy var appearance = UITabBarAppearance().then {
        $0.configureWithOpaqueBackground()
        $0.backgroundColor = .systemGray5
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
        
        setupTabBarAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let window = UIWindow.key else { return }
        let height = window.safeAreaInsets.bottom + 50
        _tabBarHeight = height
        tabBar.frame.size.height = height
        tabBar.frame.origin.y = view.frame.height - height
    }
    
    
    // Custom Method: -
    @discardableResult
    func selectTabBarWith(index: TabPage) -> FlowContributors {
        switchToTabBar(page: index)
        
        return .none
    }
    
    func switchToTabBar(page: TabPage) {
        tapTransition(toIndex: page.rawValue)
        selectedIndex = page.rawValue
    }
    
    func tabBarImageInsetSetting(tabBarItems: [UITabBarItem], selectItem: UITabBarItem) {
        for tabBarItem in tabBarItems {
            tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if tabBarItem == selectItem {
                tabBarItem.imageInsets = UIEdgeInsets(top: -3.33, left: 0, bottom: 3.33, right: 0)
            }
        }
    }
    
    // Delegate Func
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers,
              let index = tabViewControllers.firstIndex(of: viewController) else { return false }
        selectedIndex = index
        return true
    }
    
    func setupTabBarAppearance() {
        tabBar.standardAppearance = appearance
        UITabBar.appearance().backgroundColor = .systemGray5
        tabBar.tintColor = .black
    }
}

extension BaseTabBarController {
    
    func tapTransition(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return }

        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex else { return }

        fromView.superview?.addSubview(toView)
    }
}

extension UITabBarItem {
    static func setupBarItem() {
        UITabBarItem
            .appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.notoSans(.regular, size: 13),
                 NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                ], for: .normal)

        UITabBarItem
            .appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.notoSans(.regular, size: 13),
                 NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha:  1)
                ], for: .focused)

        UITabBarItem
            .appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.notoSans(.regular, size: 13),
                 NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                ], for: .selected)
    }
}
