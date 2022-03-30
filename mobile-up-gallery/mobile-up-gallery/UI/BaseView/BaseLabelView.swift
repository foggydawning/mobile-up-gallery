//
//  BaseLabelView.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 29.03.2022.
//

import UIKit

class BaseLabelView: UILabel {

    init() {
        super.init(frame: .zero)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {
        numberOfLines = 0
        lineBreakStrategy = []
        textColor = .main
    }
}
