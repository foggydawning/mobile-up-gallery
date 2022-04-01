//
//  LoginModel.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 30.03.2022.
//

// MARK: - LoginModel
final class LoginModel {

    // MARK: Properties
    private weak var controller: LoginVC?

    private var token: String? { didSet { tokenDidSet() }}

    private var tokenIsActive: Bool? { didSet {
        if tokenIsActive == true { openMainScreen() }}
    }

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

    private func tokenDidSet() {
        guard let token = token else {
            UserSettings.token = nil
            return
        }
        VKAPIManager.checkToken(token: token, completion: { [self] result in
            switch result {
            case .success(let tokenIsActiveResult):
                tokenIsActive = tokenIsActiveResult
            case .failure(let error):
                controller?.showAlert(title: error.title, message: error.message, action: {})
            }
        })
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
