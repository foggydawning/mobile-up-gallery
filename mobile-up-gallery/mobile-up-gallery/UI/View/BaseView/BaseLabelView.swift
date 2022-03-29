//
//  BaseLabelView.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 29.03.2022.
//

import UIKit

class BaseLabelView: UILabel, BaseViewProtocol {

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupAppearance() {
        numberOfLines = 0
        lineBreakStrategy = []
        textColor = .main
    }

    func setupSubviews() {}
    func setupConstraints() {}
}
