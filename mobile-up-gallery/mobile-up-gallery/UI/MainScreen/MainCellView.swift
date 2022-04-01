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
            guard let url = url else { return }
            loadImage(url: url)
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
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        addSubview(imageView)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Download image method
extension MainCellView {
    func loadImage(url: String) {
        self.imageView.image = nil

        if let imageFromCache = imageCache.object(forKey: url as NSString) {
            self.imageView.image = imageFromCache
            return
        }

        Loader.loadData(url: self.url ?? "", completion: { result in
            var imageToCache = UIImage()

            switch result {
            case .success(let data):
                guard let imageFromData = UIImage(data: data) else { return }
                imageToCache =  imageFromData
            default: break
            }
            DispatchQueue.main.async {
                self.imageView.image = imageToCache
                imageCache.setObject(imageToCache, forKey: url as NSString)
            }
        })
    }
}
