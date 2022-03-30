//
//  AuthModel.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 30.03.2022.
//

import Alamofire
import WebKit

// MARK: - AuthModel
final class AuthModel: NSObject {

    // MARK: Properties
    private weak var controller: AuthVC?
    private var requestOfCode: URLRequest?
    private var accessTokenURL: URL?
    private let clientID = "8119428"
    private let stringURLAuthorize = "https://oauth.vk.com/authorize"
    private let stringURLBlank = "https://oauth.vk.com/blank.html"
    private let stringURLTokenAccess = "https://oauth.vk.com/access_token"
    private let clientSecretKey = "c3amTH3r8eUeIWe4wTSK"

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
        setRequestOfCode()
        guard let requestOfCode = requestOfCode else {
            let description = "requestOfCode is nil"
            requestErrorAllertAndDismissController(description: description,
                                                   type: .appError)
            return
        }
        controller?.webViewLoad(request: requestOfCode)
    }

    private func dismissController() {
        controller?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private set methods
extension AuthModel {
    private func setRequestOfCode() {
        guard var urlComponents = URLComponents(string: stringURLAuthorize) else {
            requestOfCode = nil
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: stringURLBlank),
            URLQueryItem(name: "display", value: "mobile")
        ]
        guard let url = urlComponents.url else {
            requestOfCode = nil
            return
        }
        requestOfCode = URLRequest(url: url)
    }

    private func setAccessTokenURL(code: String) {
        guard var urlComponents = URLComponents(string: stringURLTokenAccess) else {
            accessTokenURL = nil
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecretKey),
            URLQueryItem(name: "redirect_uri", value: stringURLBlank),
            URLQueryItem(name: "code", value: code)
        ]
        let url = urlComponents.url
        accessTokenURL = url
    }
}

// MARK: - Implementation WKNavigationDelegate method
extension AuthModel: WKNavigationDelegate {
    func webView (
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
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
            requestAccessTocken(code: code)
        }
        decisionHandler(.allow)
    }
}

// MARK: - Public and private methods for the working with the network
extension AuthModel {
    private func requestAccessTocken(code: String) {
        setAccessTokenURL(code: code)
        guard let accessTokenURL = accessTokenURL else {
            let description = "accessTokenURL is nil"
            requestErrorAllertAndDismissController(description: description,
                                                   type: .appError)
            return
        }
        let request = AF.request(accessTokenURL)
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    guard let jsonObject = jsonObject else {
                        let description = "Error while decoding response"
                        self.requestErrorAllertAndDismissController(description: description,
                                                               type: .serverError)
                        return
                    }
                    self.processTheJSONResponse(jsonObject: jsonObject)
                } catch {
                    let description = "Error while decoding response"
                    self.requestErrorAllertAndDismissController(description: description,
                                                           type: .serverError)
                }
            case .failure(let error):
                let description = error.localizedDescription
                self.requestErrorAllertAndDismissController(description: description,
                                                       type: .serverError)
            }
        }
        dismissController()
    }

    private func processTheJSONResponse(jsonObject: [String: Any]) {
        if jsonObject.keys .contains( "access_token" ) {
            guard let token = jsonObject["access_token"] else {
                let description = "jsonObject.first?.value is empty"
                requestErrorAllertAndDismissController(description: description,
                                                       type: .serverError)
                return
            }
            controller?.handleTokenChanged(token: "\(token)")
        } else {
            let description = "\(jsonObject)"
            requestErrorAllertAndDismissController(description: description,
                                                   type: .unknownError)
        }
    }
}

// MARK: - Private error methods
extension AuthModel {
    private func requestErrorAllertAndDismissController(
        description: String, type: AuthErrorType
    ) {
        self.controller?.showAlert(title: type.title,
                                   message: type.message,
                                   action: self.dismissController)
        print(description)
    }

    private func requestPresentationControllerDismissErrorAndDismissController() {
        let type: AuthErrorType = .closingAuthenticationWindow
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
