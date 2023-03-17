//
//  SwiftUi_with_FirebaseApp.swift
//  SwiftUi-with-Firebase
//
//  Created by Hakan Gül on 17.03.2023.
//

import SwiftUI
import Firebase


@main
struct SwiftUi_with_FirebaseApp: App {
    
//    init(){
//        FirebaseApp.configure()
//        print("Configured Firebase!")
//    }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
