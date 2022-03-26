//
//  AppDelegate.swift
//  Notes
//
//  Created by Никита Андриянников on 22.03.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Preload Data from HelloNote.plist

    private func preloadData() {
        let dataStoreManager = DataStoreManager()
        let preloadedDataKey = "didPreloadData"

        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) == false {
            // get URLPath for plist

            guard let urlPath = Bundle.main.url(forResource: "HelloNote", withExtension: "plist") else {
                return
            }

            let backgroundContext = dataStoreManager.backgroundContext
            dataStoreManager.viewContext.automaticallyMergesChangesFromParent = true

            backgroundContext.perform {
                if let arrayContents = NSArray(contentsOf: urlPath) as? [String] {
                    do {
                        let note = Note(context: backgroundContext)
                        note.title = arrayContents[0]
                        note.content = arrayContents[1]

                        try backgroundContext.save()

                        userDefaults.set(true, forKey: preloadedDataKey)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
