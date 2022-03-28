//
//  LoginVC.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 28.03.2022.
//

import UIKit

class LoginVC: UIViewController {

    private lazy var loginView: LoginView = {
        LoginView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
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
