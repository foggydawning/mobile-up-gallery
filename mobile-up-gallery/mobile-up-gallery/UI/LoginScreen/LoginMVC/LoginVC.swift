//
//  LoginVC.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 28.03.2022.
//

import UIKit

// MARK: - LoginVC
class LoginVC: UIViewController {

    // MARK: Properties
    private lazy var model = LoginModel()

    // MARK: Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        model.setController(controller: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subview
    private lazy var loginView: LoginView = {
        let view = LoginView()
        view.setupButtonAction(responder: self, action: #selector(onLoginClick))
        return view
    }()
}

// MARK: - LifeCycle
extension LoginVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private setup methods
extension LoginVC {
    private func setup() {
        navigationController?.hidesBarsWhenVerticallyCompact = true
        addSubviews()
        setupConstraint()
    }

    private func addSubviews() {
        view.addSubview(loginView)
    }

    private func setupConstraint() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Public methods for connecting the model and the view
extension LoginVC {
    @objc private func onLoginClick() {
        model.login()
    }
}
