//
//  BaseViewProtocol.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 28.03.2022.
//

protocol BaseViewProtocol {
    func setupAppearance()
    func setupSubviews()
    func setupConstraints()

    func setup()
}

extension BaseViewProtocol {
    func setup() {
        setupAppearance()
        setupSubviews()
        setupConstraints()
    }
}
