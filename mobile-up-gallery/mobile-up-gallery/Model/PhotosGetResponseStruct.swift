//
//  PhotosGetResponseStruct.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 31.03.2022.
//

struct PhotosGetResponseStruct: Decodable {
    let response: PhotosGetResponseStructResponse

    enum CodingKeys: String, CodingKey {
      case response
    }
}

struct PhotosGetResponseStructResponse: Decodable {
    let count: Int
    let items: [PhotosGetResponseStructPhoto]

    enum CodingKeys: String, CodingKey {
      case count
      case items
    }
}

struct PhotosGetResponseStructPhoto: Decodable {
    let id: Int
    let date: Int
    let sizes: [PhotosGetResponseStructPhotoSize]

    enum CodingKeys: String, CodingKey {
      case id
      case date
      case sizes
    }
}

struct PhotosGetResponseStructPhotoSize: Decodable {
    let height: Int
    let width: Int
    let url: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case height
        case width
        case url
        case type
    }
}
