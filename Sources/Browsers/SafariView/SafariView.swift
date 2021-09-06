import SwiftUI
import SafariServices
import Presentation

public struct Safari {

    public typealias DismissHandler = () -> Void
    public typealias ActivitiesHandler = (_ url: URL, _ title: String?) -> [UIActivity]
    public typealias ExcludedActivitiesHandler = (_ url: URL, _ title: String?) -> [UIActivity.ActivityType]

    let configuration: SFSafariViewController.Configuration?

    var preferredBarTintColor: UIColor?
    var preferredControlTintColor: UIColor?
    var dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done

    var activities: ActivitiesHandler?
    var excludedActivities: ExcludedActivitiesHandler?

    public init(
        configuration: SFSafariViewController.Configuration? = nil,
        activities: ActivitiesHandler? = nil,
        excludedActivities: ExcludedActivitiesHandler? = nil,
        preferredBarTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done
    ) {
        self.configuration = configuration
        self.activities = activities
        self.excludedActivities = excludedActivities
        self.preferredBarTintColor = preferredBarTintColor
        self.preferredControlTintColor = preferredControlTintColor
        self.dismissButtonStyle = dismissButtonStyle
    }

}

extension Safari {
    public struct Destination: Identifiable {
        public var id: String { url.absoluteString }

        public let url: URL

        public init(url: URL) {
            self.url = url
        }
    }
}

internal struct SafariView: View {

    let url: URL
    let safari: Safari
    let onDismiss: Safari.DismissHandler

    init(url: URL, safari: Safari, onDismiss: @escaping Safari.DismissHandler) {
        self.url = url
        self.safari = safari
        self.onDismiss = onDismiss
    }

    var body: some View {
        Representable(url: url, safari: safari, onDismiss: onDismiss)
            .edgesIgnoringSafeArea(.all)
    }

}

extension URL: Identifiable {
    public var id: String { absoluteString }
}

public extension View {
    func safari(url: Binding<URL?>, style: UIModalPresentationStyle = .fullScreen, onDismiss: Safari.DismissHandler? = nil, configuration: @escaping (URL) -> Safari) -> some View {
        present(item: url, isModal: true, style: style) {
            url.wrappedValue = nil
            onDismiss?()
        } content: { wrappedUrl in
            SafariView(url: wrappedUrl, safari: configuration(wrappedUrl)) {
                url.wrappedValue = nil
                onDismiss?()
            }
        }
    }
}
