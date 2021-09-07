//import SwiftUI
//import WebKit
//
//extension WebView {
//
//    /// A web view representing content from a string
//    /// - Parameters:
//    ///   - html: The string to use as the contents of the webpage
//    ///   - baseUrl: The base URL to use when resolving relative URLs within the HTML string.
//    public init(html: String, baseUrl: URL? = nil, observer: WebViewObserver? = nil) {
//        self.source = .constant(.html(html, baseUrl: baseUrl))
//        self.observer = observer ?? .init()
//    }
//
//    /// A web view representing content from a file
//    /// - Parameters:
//    ///   - fileUrl: The URL of a file that contains web content. This URL must be a file-based URL.
//    ///   - readAccessUrl: The URL from which to read the web content must be a file-based URL. Specify the same value as the URL parameter to prevent WebKit from reading any other content. Specify a directory to give WebKit permission to read additional files in the specified directory.
//    public init(fileUrl: URL, readAccessUrl: URL? = nil, observer: WebViewObserver? = nil) {
//        self.source = .constant(.fileUrl(fileUrl, readAccessUrl: readAccessUrl ?? fileUrl))
//        self.observer = observer ?? .init()
//    }
//
//    /// A web view representing content from a remote service
//    /// - Parameter url: The remote url to the web content.
//    public init(url: URL, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60, observer: WebViewObserver? = nil) {
//        self.source = .constant(.url(url, cachePolicy: cachePolicy, timeout: timeoutInterval))
//        self.observer = observer ?? .init()
//    }
//
//    /// A web view representing content from a remote service
//    /// - Parameter request: A URL request that specifies the resource to display.
//    public init(request: URLRequest, observer: WebViewObserver? = nil) {
//        self.source = .constant(.request(request))
//        self.observer = observer ?? .init()
//    }
//
//}
//
///// A view that can display web content (backed by `WKWebView`)
//internal struct WebView: View {
//
//    public typealias Content = AnyView
//
//    public struct Navigation {
//        public let underlyingNavigation: WKNavigation
//        public let isProvisional: Bool
//    }
//
//    public typealias ChallengeCompletion = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
//    public typealias ChallengeHandler = (_ challenge: URLAuthenticationChallenge, _ completion: @escaping ChallengeCompletion) -> Void
//    public typealias ResponsePolicyHandler = (WKNavigationResponse) -> WKNavigationResponsePolicy
//    public typealias ActionPolicyHandler = (WKNavigationAction) -> WKNavigationActionPolicy
//    public typealias BeganHandler = (Navigation) -> Void
//    public typealias FailedHandler = (Navigation, Error) -> Void
//    public typealias EndedHandler = () -> Void
//
//    fileprivate enum Source {
//        case request(URLRequest)
//        case url(URL, cachePolicy: URLRequest.CachePolicy, timeout: TimeInterval)
//        case fileUrl(URL, readAccessUrl: URL)
//        case html(String, baseUrl: URL?)
//    }
//
//    fileprivate let source: Binding<Source>
//    fileprivate var config: WKWebViewConfiguration?
//    fileprivate var actionHandler: ActionPolicyHandler?
//    fileprivate var responseHandler: ResponsePolicyHandler?
//    fileprivate var beganHandler: BeganHandler?
//    fileprivate var failedHandler: FailedHandler?
//    fileprivate var endedHandler: EndedHandler?
//    fileprivate var challengeHandler: ChallengeHandler?
//
//    @ObservedObject fileprivate var observer: WebViewObserver
//
//    public var body: some View {
//        Representable(
//            source: source,
//            config: config,
//            responseHandler: responseHandler,
//            actionHandler: actionHandler,
//            beganHandler: beganHandler,
//            failedHandler: failedHandler,
//            endedHandler: endedHandler,
//            challengeHandler: challengeHandler,
//            observer: observer
//        )
//    }
//
//    /// Specifies the configuration to apply to this web view
//    public func configuration(_ configure: () -> WKWebViewConfiguration) -> WebView {
//        var view = self
//        view.config = configure()
//        return view
//    }
//
//    /// Called when navigation begins, allowing you to provide a decision policy (defaults to `.allow`)
//    public func navigationPolicy(_ decisionHandler: @escaping ActionPolicyHandler) -> WebView {
//        var view = self
//        view.actionHandler = decisionHandler
//        return view
//    }
//
//    /// Called when a response is received for a provisional navigation, allowing you to provide a decision policy (defaults to `.allow`)
//    public func responsePolicy(_ decisionHandler: @escaping ResponsePolicyHandler) -> WebView {
//        var view = self
//        view.responseHandler = decisionHandler
//        return view
//    }
//
//    /// Called when navigation begins
//    ///
//    /// Note: The handler includes a `Navigation` instance to determine if this is provisional or part of an actual page load event
//    public func onBegan(_ beganHandler: @escaping BeganHandler) -> WebView {
//        var view = self
//        view.beganHandler = beganHandler
//        return view
//    }
//
//    /// Called when navigation fails, with the associated error
//    ///
//    /// Note: The handler includes a `Navigation` instance to determine if this was provisional or part of an actual page load event
//    public func onFailed(_ failedHandler: @escaping FailedHandler) -> WebView {
//        var view = self
//        view.failedHandler = failedHandler
//        return view
//    }
//
//    /// Called when the navigation has finished loading successfully
//    public func onEnded(_ endedHandler: @escaping EndedHandler) -> WebView {
//        var view = self
//        view.endedHandler = endedHandler
//        return view
//    }
//
//    /// Called when a security challenge is encountered. Defaults to `(.useCredential, proposed)`
//    public func onChallenge(_ handler: @escaping ChallengeHandler) -> some View {
//        var view = self
//        view.challengeHandler = handler
//        return view
//    }
//
//}
//
//private extension WebView {
//
//    struct Representable: UIViewRepresentable {
//
//        let source: Binding<Source>
//        let config: WKWebViewConfiguration?
//        let responseHandler: ResponsePolicyHandler?
//        let actionHandler: ActionPolicyHandler?
//        var beganHandler: BeganHandler?
//        var failedHandler: FailedHandler?
//        var endedHandler: EndedHandler?
//        var challengeHandler: ChallengeHandler?
//
//        @ObservedObject var observer: WebViewObserver
//
//        func makeCoordinator() -> Coordinator {
//            Coordinator(source: source, config: config, observer: observer)
//        }
//
//        func makeUIView(context: Context) -> WKWebView {
//            context.coordinator.observer.webView
//        }
//
//        func updateUIView(_ view: WKWebView, context: Context) {
//            context.coordinator.update(
//                source: source,
//                actionHandler: actionHandler,
//                responseHandler: responseHandler,
//                beganHandler: beganHandler,
//                failedHandler: failedHandler,
//                endedHandler: endedHandler,
//                challengeHandler: challengeHandler
//            )
//        }
//
//    }
//
//}
//
//private extension WebView.Representable {
//
//    final class Coordinator: NSObject, WKNavigationDelegate {
//
//        let source: Binding<WebView.Source>
//
//        var responseHandler: WebView.ResponsePolicyHandler?
//        var actionHandler: WebView.ActionPolicyHandler?
//        var beganHandler: WebView.BeganHandler?
//        var failedHandler: WebView.FailedHandler?
//        var endedHandler: WebView.EndedHandler?
//        var challengeHandler: WebView.ChallengeHandler?
//
//        @ObservedObject var observer: WebViewObserver
//
//        init(
//            source: Binding<WebView.Source>,
//            config: WKWebViewConfiguration?,
//            observer: WebViewObserver
//        ) {
//            self.source = source
//            self.observer = observer
//
//            super.init()
//
//            observer.webView.isOpaque = false
//            observer.webView.backgroundColor = nil
//            observer.webView.scrollView.backgroundColor = nil
//            observer.webView.allowsBackForwardNavigationGestures = false
//            observer.webView.navigationDelegate = self
//        }
//
//        func update(
//            source: Binding<WebView.Source>,
//            actionHandler: WebView.ActionPolicyHandler?,
//            responseHandler: WebView.ResponsePolicyHandler?,
//            beganHandler: WebView.BeganHandler?,
//            failedHandler: WebView.FailedHandler?,
//            endedHandler: WebView.EndedHandler?,
//            challengeHandler: WebView.ChallengeHandler?
//        ) {
//            self.actionHandler = actionHandler
//            self.responseHandler = responseHandler
//            self.beganHandler = beganHandler
//            self.failedHandler = failedHandler
//            self.endedHandler = endedHandler
//            self.challengeHandler = challengeHandler
//
//            switch source.wrappedValue {
//            case let .html(string, baseUrl):
//                observer.webView.loadHTMLString(string, baseURL: baseUrl)
//            case let .fileUrl(url, readAccessUrl):
//                observer.webView.loadFileURL(url, allowingReadAccessTo: readAccessUrl)
//            case let .url(url, policy, timeout):
//                observer.webView.load(URLRequest(url: url, cachePolicy: policy, timeoutInterval: timeout))
//            case let .request(request):
//                observer.webView.load(request)
//            }
//        }
//
//        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//            decisionHandler(responseHandler?(navigationResponse) ?? .allow)
//        }
//
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            let policy = actionHandler?(navigationAction) ?? .allow
//            if policy == .allow {
//                source.wrappedValue = .request(navigationAction.request)
//            }
//            decisionHandler(policy)
//        }
//
//        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//            if let handler = challengeHandler {
//                handler(challenge, completionHandler)
//            } else {
//                completionHandler(.useCredential, challenge.proposedCredential)
//            }
//        }
//
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            beganHandler?(WebView.Navigation(underlyingNavigation: navigation, isProvisional: true))
//        }
//
//        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//            beganHandler?(WebView.Navigation(underlyingNavigation: navigation, isProvisional: false))
//        }
//
//        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            failedHandler?(WebView.Navigation(underlyingNavigation: navigation, isProvisional: true), error)
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            failedHandler?(WebView.Navigation(underlyingNavigation: navigation, isProvisional: false), error)
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            endedHandler?()
//        }
//
//    }
//
//}
//
//struct WebView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebView(url: URL(string: "https://apple.com")!)
//            .edgesIgnoringSafeArea(.bottom)
//            .preferredColorScheme(.dark)
//    }
//}
