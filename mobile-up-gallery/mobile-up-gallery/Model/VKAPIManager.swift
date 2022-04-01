//
//  VKAPIManager.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 01.04.2022.
//

import Alamofire
import Foundation

// MARK: - VKAPIManager
final class VKAPIManager {

    // MARK: Properties
    static let apiVersion = "5.131"

    static let clientID = "8119428"
    static let clientSecretKey = "c3amTH3r8eUeIWe4wTSK"

    static let strURLForGetProfileInfoRequest = "https://api.vk.com/method/account.getProfileInfo"
    static let strURLAuthorize = "https://oauth.vk.com/authorize"
    static let strURLBlank = "https://oauth.vk.com/blank.html"
    static let strURLTokenAccess = "https://oauth.vk.com/access_token"
    static let strURLPhotosGet = "https://api.vk.com/method/photos.get"
}

// MARK: - Static methods
extension VKAPIManager {

    static func getURLRequestOfCode() -> URLRequest? {
        guard var urlComponents = URLComponents(string: strURLAuthorize) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: strURLBlank),
            URLQueryItem(name: "display", value: "mobile")
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    static func checkToken(token: String, completion: @escaping (Result<Bool, ErrorType>) -> Void ) {
        AF.request(strURLForGetProfileInfoRequest,
                   method: .get,
                   parameters: ["access_token": token,
                                "v": self.apiVersion],
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: AccountGetProfileInfoResponseStruct.self) { response in
            guard let answer = response.value else {
                completion(.failure(.unknownError))
                return
            }
            if answer.error != nil {
                completion(.success(false))
            } else {
                completion(.success(true))
            }
        }
    }

    static func fetchPhotosInfo (
        token: String,
        completion: @escaping (Result<PhotosGetResponseStruct.Response, ErrorType>) -> Void,
        ownerID: String = "-128666765",
        albumID: String = "266276915"
    ) {
        AF.request(strURLPhotosGet,
                   method: .get,
                   parameters: ["owner_id": ownerID,
                                "album_id": albumID,
                                "photo_sizes": "0",
                                "access_token": token,
                                "v": "5.131"],
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: PhotosGetResponseStruct.self) { response in
            guard let answer = response.value else {
                completion(.failure(.unknownError))
                return
            }
            let answerResponse = answer.response
            completion(.success(answerResponse))
        }
    }

    static func getToken(code: String, completion: @escaping (Result<String, ErrorType>) -> Void ) {
        AF.request(strURLTokenAccess,
                   method: .get,
                   parameters: ["client_id": clientID,
                                "client_secret": clientSecretKey,
                                "redirect_uri": strURLBlank,
                                "code": code],
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: AccessTokenResponseStruct.self) { response in
            guard let answer = response.value,
                  answer.error == nil,
                  let token = answer.token else {
                completion(.failure(.unknownError))
                return
            }
            completion(.success(token))
        }
    }
}

// MARK: - Responses Decodable Structs
// swiftlint:disable nesting
extension VKAPIManager {
    struct AccessTokenResponseStruct: Decodable {
        let token: String?
        let error: String?

        enum CodingKeys: String, CodingKey {
            case token = "access_token"
            case error
        }
    }

    struct AccountGetProfileInfoResponseStruct: Decodable {
        let response: Response?
        let error: Error?

        enum CodingKeys: String, CodingKey {
            case response
            case error
        }

        struct Response: Decodable {
            let id: Int
            let firstName: String

            enum CodingKeys: String, CodingKey {
                case id
                case firstName = "first_name"
            }
        }
        struct Error: Decodable {
            let errorCode: Int
            let errorMessage: String

            enum CodingKeys: String, CodingKey {
                case errorCode = "error_code"
                case errorMessage = "error_message"
            }
        }
    }

    struct PhotosGetResponseStruct: Decodable {
        let response: Response

        enum CodingKeys: String, CodingKey {
          case response
        }

        struct Response: Decodable {
            let count: Int
            let items: [Photo]

            enum CodingKeys: String, CodingKey {
              case count
              case items
            }
        }

        struct Photo: Decodable {
            let id: Int
            let date: Int
            let sizes: [PhotoSize]

            enum CodingKeys: String, CodingKey {
              case id
              case date
              case sizes
            }
        }

        struct PhotoSize: Decodable {
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
    }
}
// swiftlint:enable nesting
