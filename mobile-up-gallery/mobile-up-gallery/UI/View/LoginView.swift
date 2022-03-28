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
        let label = UILabel()
        label.text = GeneralConstants.Text.appName
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakStrategy = []
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        let title: String = Bundle.main.localizedString(forKey: "loginWithVK",
                                                        value: "Login with VK",
                                                        table: "BottonLabelLocalizable")

        button.backgroundColor = .black
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8

        return button
    }()

    func setupAppearance() {
        backgroundColor = .white
    }

    func setupSubviews() {
        addSubview(label)
        addSubview(button)
    }

    func setupConstraints() {
        let leadingTrailingInset: CGFloat = 24
        let topInset: CGFloat = 164

        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalToSuperview().inset(topInset)
        }

        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(56)
        }
    }
}
