//
//  MainModel.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 31.03.2022.
//

import Foundation

// MARK: - MainModel
final class MainModel {

    // MARK: - Properties
    private weak var controller: MainVC?
    private weak var logoutDelegate: LogoutDelegate?
    private (set) var photosInfo: [Photo] = []
}

// MARK: - Public setup methods
extension MainModel {
    func setController(controller: MainVC) {
        self.controller = controller
    }
}

// MARK: - Public and private methods for the working with the network
extension MainModel {
    func setPhotosInfo() {
        guard let token = UserSettings.token else {
            controller?.showAlert(title: ErrorType.unknownError.title,
                                  message: ErrorType.unknownError.message,
                                  action: {self.logout()})
            return
        }

        VKAPIManager.fetchPhotosInfo(token: token, completion: { [self] result in
            switch result {
            case .success(let response):
                for dirtyPhotoData in response.items {
                    let datetime = dirtyPhotoData.date
                    guard let url = dirtyPhotoData.sizes.first(where: { $0.type == "z" })?.url else {
                        continue
                    }
                    let photo = Photo(datetime: datetime, url: url)
                    photosInfo.append(photo)
                }
                DispatchQueue.main.async {
                    self.controller?.collectionView?.reloadData()
                }
            case .failure(let error):
                controller?.showAlert(title: error.title,
                                      message: error.message,
                                      action: {self.logout()})
            }
        })
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
