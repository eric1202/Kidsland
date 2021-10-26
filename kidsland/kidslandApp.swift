//
//  kidslandApp.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/7/28.
//

import SwiftUI

@main
struct kidslandApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var linkActive = false

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(options)
        print(url)
        
        return true
    }
}
