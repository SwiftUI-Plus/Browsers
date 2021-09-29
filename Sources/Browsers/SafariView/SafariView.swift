import SwiftUI
import SafariServices
import Presentation

#if os(iOS)

/// Represents a Safari view controller. This view can be safely used by a `NavigationLink`. If you want to show Safari modally, its best to use the `safari` modifier instead.
public struct SafariView: View {

    let url: URL
    let safari: Safari
    let onDismiss: DismissHandler

    public init(url: URL, safari: Safari = .init(), onDismiss: @escaping DismissHandler = { }) {
        self.url = url
        self.safari = safari
        self.onDismiss = onDismiss
    }

    public var body: some View {
        Representable(url: url, safari: safari, onDismiss: onDismiss)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
    }

}

extension URL: Identifiable {
    public var id: String { absoluteString }
}

public extension View {

    /// Presents a Safari controller when a URL is available
    /// - Parameters:
    ///   - url: The URL to navigate to with Safari
    ///   - style: The presentation style
    ///   - onDismiss: Called when Safari is dismissed
    ///   - configuration: Provide a configuration for Safari
    func safari(url: Binding<URL?>, style: UIModalPresentationStyle = .fullScreen, onDismiss: DismissHandler? = nil, configuration: @escaping (URL) -> Safari) -> some View {
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

#endif
