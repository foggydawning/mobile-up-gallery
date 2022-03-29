//
//  LoginView.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 28.03.2022.
//

import UIKit
import SnapKit

class LoginView: UIView, BaseViewProtocol {
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        let button = BaseButtonView(title: title)
        return button
    }()

    func setupAppearance() {
        backgroundColor = .background
    }

    func setupSubviews() {
        addSubview(label)
        addSubview(button)
    }

    func setupConstraints() {
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
