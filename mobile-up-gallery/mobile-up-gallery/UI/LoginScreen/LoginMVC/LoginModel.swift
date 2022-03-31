//
//  LoginModel.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 30.03.2022.
//

import Alamofire

// MARK: - LoginModel
final class LoginModel {

    // MARK: Properties
    private weak var controller: LoginVC?
    private var urlForCheckToken: URL?

    private var token: String? { didSet {
        if token != nil { checkToken()
        } else { UserSettings.token = nil} }
    }
    private var tokenIsActive: Bool? { didSet {
        if tokenIsActive == true { openMainScreen() }}
    }

    private let apiVersion = "5.131"
    private let stringURLForGetProfileInfo = "https://api.vk.com/method/account.getProfileInfo"

    // MARK: Initializer
    init() {
        setup()
    }
}

// MARK: - Private setup methods
extension LoginModel {
    private func setup() {
        setToken()
    }

    private func setToken() {
        token = UserSettings.token
    }

    private func setURLForCheckToken() {
        guard var urlComponents = URLComponents(string: stringURLForGetProfileInfo) else {
            urlForCheckToken = nil
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: apiVersion)
        ]
        let url = urlComponents.url
        urlForCheckToken = url
    }
}

// MARK: - Public setup methods
extension LoginModel {
    func setController(controller: LoginVC) {
        self.controller = controller
    }
}

// MARK: - Implementation AuthViewControllerDelegate method
extension LoginModel: AuthViewControllerDelegate {
    func saveToken(token: String) {
        UserSettings.token = token
        setToken()
    }
}

// MARK: - Public and private methods for the working with the network
extension LoginModel {
    func checkToken() {
        setURLForCheckToken()
        guard let urlForCheckToken = urlForCheckToken else { return }
        let request = AF.request(urlForCheckToken)
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    guard let jsonObject = jsonObject else {
                        self.tokenIsActive = false
                        return
                    }
                    if self.isErrorInJSONResponse(jsonObject: jsonObject) {
                        self.tokenIsActive = false
                    } else {
                        self.tokenIsActive = true
                    }
                } catch {
                    self.tokenIsActive = false
                }
            case .failure(let error):
                self.tokenIsActive = false
                print(error)
            }
        }
    }

    private func isErrorInJSONResponse(jsonObject: [String: Any]) -> Bool {
        if jsonObject.keys.contains("error") {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Private methods for interacting with UIVavigationController
extension LoginModel {
    private func openMainScreen() {
        let mainVC = MainVC()
        mainVC.setLogoutDelegate(self)
        controller?.navigationController?.pushViewController(mainVC, animated: true)
    }
}

// MARK: - Public method for present authVC
extension LoginModel {
    func login() {
        guard let controller = controller else { return }
        let authVC = AuthVC(delegate: self)
        controller.present(authVC, animated: true, completion: nil)
        return
    }
}

// MARK: - LogoutDelegate Methods
extension LoginModel: LogoutDelegate {
    func logout() {
        token = nil
    }
}
