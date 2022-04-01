//
//  DetailModel.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 01.04.2022.
//

import Foundation

// MARK: - MainModel
final class DetailModel {

    // MARK: - Properties
    private weak var controller: DetailVC?
    private (set) var photoInfo: Photo?
}

// MARK: - Public setup methods
extension DetailModel {
    func setController(controller: DetailVC) {
        self.controller = controller
    }

    func setPhotoInfo(photoInfo: Photo) {
        self.photoInfo = photoInfo
    }
}

// MARK: - Public methods for interacting with the VC
extension DetailModel {
    func getDate() -> String? {
        guard let photoInfo = photoInfo else { return nil }
        let date = Date(timeIntervalSince1970: TimeInterval(photoInfo.datetime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = DateFormatter.Style.long
        var localDate = dateFormatter.string(from: date)
        localDate = localDate.replacingOccurrences(of: "г.", with: "")
        return localDate
    }
}
