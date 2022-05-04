//
//  SceneDelegate.swift
//  Basic
//
//  Created by pineone on 2021/11/05.
//

import UIKit
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator = FlowCoordinator()
    private lazy var initialFlow = { return InitFlow() }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let appFlow = self.initialFlow
        
        window = UIWindow(windowScene: scene)
        if let window = window {
            self.coordinator.coordinate(flow: appFlow, with: AppStepper.shared)
            Flows.use(appFlow, when: .created) { root in
                if let naviRoot = root as? BaseNavigationController {
                    window.rootViewController = naviRoot
                    window.makeKeyAndVisible()
                }
            }
        }
    }
}
