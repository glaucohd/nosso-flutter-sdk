//
//  ContentView.swift
//  poc
//
//  Created by Glauco on 28/04/26.
//

import SwiftUI
import NossoFlutterSDK

struct ContentView: View {
    let sdk: NossoFlutterSDK

    @State private var isNavigatingToFlutterSdk = false

    private let demoAuthToken = "ios-demo-token-1234567890"

    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    sdk.start(authToken: demoAuthToken)
                    isNavigatingToFlutterSdk = true
                } label: {
                    Text("Abrir SDK Flutter")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("App iOS")
            .navigationDestination(isPresented: $isNavigatingToFlutterSdk) {
                NossoFlutterSDKView(sdk: sdk)
                    .ignoresSafeArea()
                    .navigationTitle("SDK Flutter")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ContentView(sdk: .shared)
}
