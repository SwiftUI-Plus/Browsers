import SwiftUI
import SafariServices
import Presentation

#if os(iOS)

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

    /// Presents a Safari controller when a URL is available
    /// - Parameters:
    ///   - url: The URL to navigate to with Safari
    ///   - style: The presentation style
    ///   - onDismiss: Called when Safari is dismissed
    ///   - configuration: Provide a configuration for Safari
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

#endif
