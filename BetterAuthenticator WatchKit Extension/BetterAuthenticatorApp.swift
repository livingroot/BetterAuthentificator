//
//  BetterAuthenticatorApp.swift
//  BetterAuthenticator WatchKit Extension
//
//  Created by livingroot on 15.06.2021.
//

import SwiftUI

@main
struct BetterAuthenticatorApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
