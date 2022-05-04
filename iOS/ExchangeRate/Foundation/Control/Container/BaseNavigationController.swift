//
//  BaseNavigationController.swift
//  Basic
//
//  Created by pineone on 2021/09/14.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class BaseNavigationController: UINavigationController {
    static let shared = BaseNavigationController()
    var forceAnimation = false
    var isEnableForceAnimation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = rx.willShow.subscribe(onNext: { [weak self] viewController in
            self?.navigationBar.isTranslucent = false
            self?.navigationBar.isHidden = true

            if viewController.interactivePopGestureRecognizer {
                self?.interactivePopGestureRecognizer?.delegate = self
            }
            
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            viewController.navigationItem.backBarButtonItem = backBarButtonItem
        })
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: isEnableForceAnimation ? forceAnimation : animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: isEnableForceAnimation ? forceAnimation : animated)
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return super.popToViewController(viewController, animated: isEnableForceAnimation ? forceAnimation : animated)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return super.popToRootViewController(animated: isEnableForceAnimation ? forceAnimation : animated)
    }
}

// MARK: - Rotate Display
extension BaseNavigationController {
    override var shouldAutorotate: Bool {
        if let topVC = self.topViewController {
            return topVC.shouldAutorotate
        }
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let topVC = self.topViewController {
            return topVC.supportedInterfaceOrientations
        }
        return .portrait
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class RxNavigationControllerDelegateProxy: DelegateProxy<UINavigationController, UINavigationControllerDelegate>, DelegateProxyType, UINavigationControllerDelegate {
    /// Typed parent object.
    public private(set) weak var navigationController: UINavigationController?

    static func registerKnownImplementations() {
        self.register { RxNavigationControllerDelegateProxy(navigationController: $0) }
    }

    public init(navigationController: ParentObject) {
        self.navigationController = navigationController
        super.init(parentObject: navigationController, delegateProxy: RxNavigationControllerDelegateProxy.self)
    }

    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let navigationController = object as! UINavigationController
        navigationController.delegate = (delegate as? UINavigationControllerDelegate)
    }

    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        return (object as! UINavigationController).delegate
    }
}

extension Reactive where Base: UINavigationController {
    var delegate: DelegateProxy<UINavigationController, UINavigationControllerDelegate> {
        return RxNavigationControllerDelegateProxy.proxy(for: base)
    }

    var willShow: Observable<UIViewController> {
        return delegate
            .methodInvoked(#selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:)))
            .map { $0[1] as! UIViewController }
    }

    var didShow: Observable<UIViewController> {
        return delegate
            .methodInvoked(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { $0[1] as! UIViewController }
    }
}

extension UIViewController {
    @objc
    var interactivePopGestureRecognizer: Bool {
        return true
    }
}
