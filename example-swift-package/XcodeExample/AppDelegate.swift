import UIKit
import ofxiOSBoostBridge

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let linked = ofxiOSBoostRunLinkTest()
        let version = String(cString: ofxiOSBoostVersion())

        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = linked
            ? "Boost \(version) linked through Swift Package Manager"
            : "Boost link test failed"

        let controller = UIViewController()
        controller.view.backgroundColor = .white
        controller.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -24),
            label.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor)
        ])

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
