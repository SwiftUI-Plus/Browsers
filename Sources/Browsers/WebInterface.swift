import SwiftUI
import Combine
import WebKit

public final class WebViewObserver: ObservableObject {

    @Published public private(set) var webView: WKWebView
    @Published public private(set) var progress: Double = 0

    private var titleCancel: AnyCancellable?
    private var urlCancel: AnyCancellable?

    private var canGoBackCancel: AnyCancellable?
    private var canGoForwardCancel: AnyCancellable?

    private var isLoadingCancel: AnyCancellable?
    private var progressCancel: AnyCancellable?

    public init(config: WKWebViewConfiguration? = nil) {
        if let config = config {
            webView = WKWebView(frame: .zero, configuration: config)
        } else {
            webView = WKWebView(frame: .zero)
        }

//        isLoadingCancel = webView
//            .publisher(for: \.isLoading)
//            .debounce(for: 0.5, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .sink { [weak self] _ in
//                self?.objectWillChange.send()
//            }

//        titleCancel = webView.publisher(for: \.title, options: .new)
//            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
//            .assign(to: \.title, on: self)

//        urlCancel = webView.publisher(for: \.url)
//            .assign(to: \.url, on: self)
//        canGoBackCancel = webView.publisher(for: \.canGoBack)
//            .assign(to: \.canGoBack, on: self)
//        canGoForwardCancel = webView.publisher(for: \.canGoForward)
//            .assign(to: \.canGoForward, on: self)
//

//        isLoadingCancel = webView.publisher(for: \.isLoading, options: [.initial, .new])
//            .assign(to: \.isLoading, on: self)

        progressCancel = webView.publisher(for: \.estimatedProgress)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.progress = value
            }
    }

    public func stopLoading() {
        webView.stopLoading()
    }

    public func reload(fromOrigin: Bool = false) {
        if fromOrigin {
            webView.reloadFromOrigin()
        } else {
            webView.reload()
        }
    }

}
