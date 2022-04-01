//
//  DetailVC.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 01.04.2022.
//

import UIKit
import SnapKit

// MARK: - DetailVC
final class DetailVC: UIViewController {

    // MARK: Properties
    private lazy var model: DetailModel = {
        let model = DetailModel()
        model.setController(controller: self)
        return model
    }()

    // MARK: Initializers
    init(photoInfo: Photo) {
        super.init(nibName: nil, bundle: nil)
        model.setPhotoInfo(photoInfo: photoInfo)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Subviews
    private lazy var titleLabel: UILabel = {
        NavigationBarTitleLabelView(text: model.getDate() ?? "")
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let mediumConfig = UIImage.SymbolConfiguration(weight: .semibold)
        button.setImage(UIImage(systemName: "chevron.backward",
                                withConfiguration: mediumConfig) ?? UIImage(),
                        for: .normal)
        button.tintColor = .main
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        let mediumConfig = UIImage.SymbolConfiguration(weight: .semibold)
        button.setImage(UIImage(named: "ShareIcon") ?? UIImage(),
                        for: .normal)
        button.tintColor = .main
        button.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        Loader.loadData(url: model.photoInfo?.url ?? "",
                        completion: { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { imageView.image = UIImage(data: data) }
            default: break
            }
        })
        imageView.backgroundColor = .systemGray
        return imageView
    }()
}

// MARK: - LifeCycle
extension DetailVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private setup methods
extension DetailVC {
    private func setup() {
        setupAppearence()
        setupSubviews()
        setupConstraints()
    }

    private func setupAppearence() {
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        view.backgroundColor = .background
    }

    private func setupSubviews() {
        view.addSubview(imageView)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Button methods
extension DetailVC {
    @objc private func dismissSelf() {
        navigationController?.popViewController(animated: true)
    }

    // swiftlint:disable closure_parameter_position
    @objc private func shareImage() {
        guard let image = imageView.image else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true)
        shareController.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?,
             completed: Bool, _: [Any]?,
             error: Error?) in
            switch completed {
            case true:
                switch activityType {
                case UIActivity.ActivityType.saveToCameraRoll:
                    let title = Bundle.main.localizedString(forKey: "imageSaved",
                                                            value: "Success",
                                                            table: "AllertTitleLocolizable")
                    let message = Bundle.main.localizedString(forKey: "imageSaved",
                                                            value: "Image saved",
                                                            table: "AllertMessageLocolizable")
                    self.showAlert(title: title, message: message, action: {})
                default: break
                }
            case false:
                guard let error = error else { return }
                let title = Bundle.main.localizedString(forKey: ErrorType.unknownError.rawValue,
                                                        value: ErrorType.unknownError.title,
                                                        table: "AllertTitleLocolizable")
                let message = Bundle.main.localizedString(forKey: "imageSaved",
                                                        value: ErrorType.unknownError.rawValue,
                                                        table: "AllertMessageLocolizable")
                self.showAlert(title: title, message: message, action: {})
                print(error.localizedDescription)
            }
        }
    }
    // swiftlint:enable closure_parameter_position
}
