//
//  MainModel.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 31.03.2022.
//

import Alamofire

// MARK: - MainModel
final class MainModel {

    // MARK: - Properties
    private weak var controller: MainVC?
    private weak var logoutDelegate: LogoutDelegate?
    private (set) var photos: [Photo] = []
}

// MARK: - Public setup methods
extension MainModel {
    func setController(controller: MainVC) {
        self.controller = controller
    }
}

// MARK: - Public and private methods for the working with the network
extension MainModel {
    func fetchPhotos() {
        guard let token = UserSettings.token else { return }

        AF.request("https://api.vk.com/method/photos.get",
                   method: .get,
                   parameters: ["owner_id": "-128666765",
                                "album_id": "266276915",
                                "photo_sizes": "0",
                                "access_token": token,
                                "v": "5.131"],
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: PhotosGetResponseStruct.self) { response in
            guard let photosGetResponseStruct = response.value else { return }
            let photosGetResponseStructResponse = photosGetResponseStruct.response
            self.setPhotos(photosGetResponseStructResponse: photosGetResponseStructResponse)
        }
    }

    private func setPhotos(photosGetResponseStructResponse: PhotosGetResponseStructResponse) {
        for dirtyPhotoData in photosGetResponseStructResponse.items {
            let datetime = dirtyPhotoData.date
            guard let url = dirtyPhotoData.sizes.first(where: { $0.type == "x" })?.url else {
                continue
            }
            let photo = Photo(datetime: datetime, url: url)
            photos.append(photo)
        }
        DispatchQueue.main.async {
            self.controller?.collectionView?.reloadData()
        }
    }
}

// MARK: - Public methods for interacting with the model
extension MainModel {
    func setLogoutDelegate(_ logoutDelegate: LogoutDelegate) {
        self.logoutDelegate = logoutDelegate
    }

    func logout() {
        guard let logoutDelegate = logoutDelegate,
              let controller = controller,
              let navigationController = controller.navigationController else { return }
        logoutDelegate.logout()
        navigationController.popViewController(animated: true)
    }
}
