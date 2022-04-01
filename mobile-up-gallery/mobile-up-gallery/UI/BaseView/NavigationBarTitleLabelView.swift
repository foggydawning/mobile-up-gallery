//
//  NavigationBarTitleLabelView.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 01.04.2022.
//

import UIKit

class NavigationBarTitleLabelView: BaseLabelView {
    init(text: String) {
        super.init()
        setup(text: text)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup(text: String) {
        self.text = text
        font = .systemFont(ofSize: 18, weight: .semibold)
    }
}
