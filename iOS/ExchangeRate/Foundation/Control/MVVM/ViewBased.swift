//
//  ViewBased.swift
//  Base
//
//  Created by pineone on 2021/08/04.
//

import Foundation
import RxSwift
import UIKit

protocol ViewBased {
    func setupLayout()
}
class UIBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.3647058824, green: 0.368627451, blue: 0.3647058824, alpha: 1)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
       // overrideAnimation()
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        overrideAnimation()
        super.dismiss(animated: flag, completion: completion)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

extension UIBaseViewController {
    func overrideAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        navigationController?.view.window?.layer.add(transition, forKey: nil)
    }
}
