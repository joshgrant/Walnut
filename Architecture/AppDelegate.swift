//
//  AppDelegate.swift
//  Architecture
//
//  Created by Joshua Grant on 6/23/21.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Variables
    
    var id: UUID = UUID()
    
    static var shared: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    
    var mainStream = Stream(identifier: .main)
    
    // MARK: - Functions
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
    {
        subscribe(to: mainStream)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions)
    -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: Subscriber
{
    func receive(event: Event)
    {
        print("APP DELEGATE: \(event)")
    }
}
