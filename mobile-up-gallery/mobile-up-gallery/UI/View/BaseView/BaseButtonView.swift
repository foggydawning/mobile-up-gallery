//
//  BaseButtonView.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 29.03.2022.
//

import UIKit

class BaseButtonView: UIButton, BaseViewProtocol {

    let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupAppearance() {
        backgroundColor = .main
        setTitle(title, for: .normal)
        setTitleColor(.background, for: .normal)
        layer.cornerRadius = 8
    }

    func setupSubviews() {

    }

    func setupConstraints() {

    }

}
