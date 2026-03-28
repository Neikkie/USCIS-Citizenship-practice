//
//  USCIS_Citizenship_practiceApp.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//
import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@main
struct USCIS_Citizenship_practiceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                    ATTrackingManager.requestTrackingAuthorization { _ in
                        MobileAds.shared.start(completionHandler: nil)
                    }
                } else {
                    MobileAds.shared.start(completionHandler: nil)
                }
            }
        }
    }
}
