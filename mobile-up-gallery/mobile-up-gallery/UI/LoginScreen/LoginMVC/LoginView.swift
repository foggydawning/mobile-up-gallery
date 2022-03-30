//
//  LoginView.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 28.03.2022.
//

import UIKit
import SnapKit

// MARK: - LoginView
class LoginView: UIView {
    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subviews
    private lazy var label: UILabel = {
        let label = BaseLabelView()
        label.text = GeneralConstants.Text.appName
        label.font = .systemFont(ofSize: 48, weight: .bold)
        return label
    }()

    private lazy var button: UIButton = {
        let title: String = Bundle.main.localizedString(forKey: "loginWithVK",
                                                        value: "Login with VK",
                                                        table: "BottonLabelLocalizable")
        let button = UIButton(type: .system)

        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)

        button.backgroundColor = .main
        button.setTitleColor(.background, for: .normal)
        button.layer.cornerRadius = 8

        return button
    }()
}

// MARK: Private setup methods
extension LoginView {

    private func setup() {
        setupAppearance()
        setupSubviews()
        setupConstraints()
    }

    private func setupAppearance() {
        backgroundColor = .background
    }

    private func setupSubviews() {
        addSubview(label)
        addSubview(button)
    }

    private func setupConstraints() {
        let leadingTrailingInset: CGFloat = 24
        let topInset: CGFloat = 164
        let bottomInset: CGFloat = 50

        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalToSuperview().inset(topInset)
        }

        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.bottom.equalToSuperview().inset(bottomInset)
            make.height.equalTo(56)
        }
    }
}

// MARK: - Public methods for for interacting with the VC
extension LoginView {
    func setupButtonAction(responder: UIResponder, action: Selector) {
        button.addTarget(responder, action: action, for: .touchUpInside)
    }
}
