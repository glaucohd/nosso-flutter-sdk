//
//  pocApp.swift
//  poc
//
//  Created by Glauco on 28/04/26.
//

import SwiftUI
import NossoFlutterSDK

@main
struct pocApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(sdk: .shared)
        }
    }
}
