import SwiftUI
import SafariServices

#if os(iOS)

extension SafariView {

    struct Representable: UIViewControllerRepresentable {

        let url: URL
        let safari: Safari
        let onDismiss: DismissHandler

        func makeCoordinator() -> Coordinator {
            Coordinator(url: url, safari: safari, onDismiss: onDismiss)
        }

        func makeUIViewController(context: Context) -> SFSafariViewController {
            context.coordinator.controller
        }

        func updateUIViewController(_ controller: SFSafariViewController, context: Context) { }
    }
    
}

extension SafariView {

    final class Coordinator: NSObject, SFSafariViewControllerDelegate, UIViewControllerTransitioningDelegate {
        let safari: Safari
        let onDismiss: DismissHandler
        let controller: SFSafariViewController

        init(url: URL, safari: Safari, onDismiss: @escaping DismissHandler) {
            if let configuration = safari.configuration {
                self.controller = SFSafariViewController(url: url, configuration: configuration)
            } else {
                self.controller = SFSafariViewController(url: url)
            }

            self.safari = safari
            self.onDismiss = onDismiss

            super.init()

            controller.delegate = self
            controller.preferredBarTintColor = safari.preferredBarTintColor
            controller.preferredControlTintColor = safari.preferredControlTintColor
            controller.dismissButtonStyle = safari.dismissButtonStyle
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            onDismiss()
        }

        func safariViewController(_ controller: SFSafariViewController, activityItemsFor url: URL, title: String?) -> [UIActivity] {
            safari.activities?(url, title) ?? []
        }

        func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor url: URL, title: String?) -> [UIActivity.ActivityType] {
            safari.excludedActivities?(url, title) ?? []
        }
    }

}

#endif
