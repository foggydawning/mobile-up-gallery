//
//  MainCellView.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 31.03.2022.
//

import UIKit
import Alamofire

let imageCache = NSCache<NSString, UIImage>()

// MARK: - MainCellView
final class MainCellView: UICollectionViewCell {

    // MARK: Properties
    var url: String? {
        didSet {
            imageView.image = nil
            loadImage()
        }
    }
    static let reuseID = String(describing: MainCellView.self)

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subviews
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
}

// MARK: - Private setup methods
extension MainCellView {
    private func setup() {
        setupAppearence()
        setupSubviews()
        setupConstraints()
    }

    private func setupAppearence() {}

    private func setupSubviews() {
        addSubview(imageView)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainCellView {
    func loadImage() {
        self.imageView.image = nil

        guard let url = url else { return }

        if let imageFromCache = imageCache.object(forKey: url as NSString) {
            self.imageView.image = imageFromCache
            return
        }

        AF.download(self.url ?? "")
            .validate()
            .responseData { response in
                if let data = response.value {
                    DispatchQueue.main.async {
                        guard let imageToCache = UIImage(data: data) else { return }
                        self.imageView.image = imageToCache
                        imageCache.setObject(imageToCache, forKey: url as NSString)
                    }
                }
            }
    }
}
