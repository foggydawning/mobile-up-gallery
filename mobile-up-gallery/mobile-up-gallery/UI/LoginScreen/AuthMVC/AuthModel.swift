//
//  AuthModel.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 30.03.2022.
//

import WebKit

// MARK: - AuthModel
final class AuthModel: NSObject {

    // MARK: Properties
    private weak var controller: AuthVC?

    // MARK: Initializers
    init(controller: AuthVC) {
        super.init()
        self.controller = controller
        setupControllerDelegate()
    }
}

// MARK: - Public and private methods for interacting with the controller
extension AuthModel {
    func getAccessToken() {
        guard   let request = VKAPIManager.getURLRequestOfCode(),
                let controller = controller
        else {
            let description = "request or VC is nil"
            requestErrorAllertAndDismissController(description: description,
                                                   type: .appError)
            return
        }
        controller.webViewLoad(request: request)
    }

    private func dismissController() {
        controller?.clearWebView()
        controller?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Implementation WKNavigationDelegate method
extension AuthModel: WKNavigationDelegate {
    func webView (
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        decisionHandler(.allow)
        if let url = navigationAction.request.url, url.path == "/blank.html" {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            let components = URLComponents(string: targetString)
            guard let code = components?.queryItems?.first(where: { $0.name == "code"})?.value else {
                let description = "code is nil"
                requestErrorAllertAndDismissController(description: description,
                                                       type: .unknownError)
                return
            }
            webView.stopLoading()
            VKAPIManager.getToken(code: code, completion: { [self] result in
                switch result {
                case .success(let token):
                    controller?.handleTokenChanged(token: token)
                case .failure(let error):
                    self.requestErrorAllertAndDismissController(description: error.rawValue, type: error)
                }
                dismissController()
            })
        }
    }
}

// MARK: - Private error methods
extension AuthModel {
    private func requestErrorAllertAndDismissController(
        description: String, type: ErrorType
    ) {
        self.controller?.showAlert(title: type.title,
                                   message: type.message,
                                   action: self.dismissController)
        print(description)
    }

    private func requestPresentationControllerDismissErrorAndDismissController() {
        let type: ErrorType = .closingAuthenticationWindow
        self.controller?.presentingViewController?.showAlert(title: type.title,
                                                           message: type.message,
                                                           action: self.dismissController)
    }
}

// MARK: - Implementation UIAdaptivePresentationControllerDelegate methods
extension AuthModel: UIAdaptivePresentationControllerDelegate {
    private func setupControllerDelegate() {
        self.controller?.presentationController?.delegate = self
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        requestPresentationControllerDismissErrorAndDismissController()
    }
}
