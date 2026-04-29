import Flutter
import SwiftUI
import UIKit

public final class NossoFlutterSDK {
    public static let shared = NossoFlutterSDK()

    private let channelName = "com.empresa.flutter_sdk/auth"
    private lazy var flutterEngine = FlutterEngine(name: "nosso_flutter_sdk_engine")
    private lazy var authChannel = FlutterMethodChannel(
        name: channelName,
        binaryMessenger: flutterEngine.binaryMessenger
    )

    private var isPrepared = false
    private var currentAuthToken: String?

    private init() {}

    public func prepare() {
        guard !isPrepared else {
            return
        }

        flutterEngine.run()
        configureAuthChannel()
        isPrepared = true
    }

    public func start(authToken: String) {
        currentAuthToken = authToken
        prepare()

        authChannel.invokeMethod("authTokenUpdated", arguments: [
            "token": authToken
        ])
    }

    public func makeViewController() -> UIViewController {
        prepare()
        return FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    }

    private func configureAuthChannel() {
        authChannel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "getAuthToken":
                result(self?.currentAuthToken)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

public struct NossoFlutterSDKView: UIViewControllerRepresentable {
    private let sdk: NossoFlutterSDK

    public init(sdk: NossoFlutterSDK = .shared) {
        self.sdk = sdk
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        sdk.makeViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
