//
//  AuthVC.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 29.03.2022.
//

import UIKit
import SnapKit
import WebKit

// MARK: - AuthViewController
final class AuthVC: UIViewController {

    // MARK: Properties
    private lazy var model = AuthModel(controller: self)
    private weak var delegate: AuthViewControllerDelegate?

    // MARK: Initializers
    init(delegate: AuthViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subview
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = model
        return webView
    }()
}

// MARK: - Lifecycle
extension AuthVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private setup methods
extension AuthVC {
    private func setup() {
        setupSubviews()
        setupConstraints()
        startModelWork()
    }

    private func setupSubviews() {
        view.addSubview(webView)
    }

    private func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Private methods for interacting with the model
extension AuthVC {
    private func startModelWork() {
        model.getAccessToken()
    }
}

// MARK: - Public methods for interacting with the model
extension AuthVC {
    func handleTokenChanged(token: String) {
        delegate?.saveToken(token: token)
    }

    func webViewLoad(request: URLRequest) {
        webView.load(request)
    }
}
