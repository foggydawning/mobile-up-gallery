//
//  MainVC.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 31.03.2022.
//

import UIKit

// MARK: - MainVC
final class MainVC: UICollectionViewController {

    // MARK: Properties
    private lazy var model: MainModel = {
        let model = MainModel()
        model.setController(controller: self)
        return model
    }()

    // MARK: Initializers
    init() {
        let layout = MainVC.getLayout()
        super.init(collectionViewLayout: layout)
        model.fetchPhotos()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Subviews
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        let text = Bundle.main.localizedString(forKey: "logout",
                                               value: "Logout",
                                               table: "ButtonLabelLocalizable")
        button.backgroundColor = nil
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(UIColor.main, for: .normal)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = BaseLabelView()
        label.text = GeneralConstants.Text.appName
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
}

// MARK: - LifeCycle
extension MainVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private setup methods
extension MainVC {
    private func setup() {
        setupAppearence()
        setupCollectionView()
    }

    private func setupAppearence() {
        navigationItem.titleView = titleLabel
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register( MainCellView.self,
                                 forCellWithReuseIdentifier: MainCellView.reuseID)
    }

    private static func getLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-1,
                                 height: UIScreen.main.bounds.width/2-1)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        return layout
    }
}

// MARK: - Private and public methods for interacting with the model
extension MainVC {
    @objc func logout() {
        model.logout()
    }

    func setLogoutDelegate(_ logoutDelegate: LogoutDelegate) {
        model.setLogoutDelegate(logoutDelegate)
    }
}

// MARK: - Override collectionView methods
extension MainVC {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return model.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let index = indexPath.item
        let url = model.photos[index].url
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCellView.reuseID,
            for: indexPath)
        guard let cell = cell as? MainCellView else { return cell }
        cell.url = url
        return cell
    }
}
