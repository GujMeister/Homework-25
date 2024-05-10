//
//  SceneDelegate.swift
//  Animations
//
//  Created by Luka Gujejiani on 10.05.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let navigatioController = UINavigationController(rootViewController: MusicPlayerVC())
        
        window?.rootViewController = navigatioController
        window?.makeKeyAndVisible()
    }
}
