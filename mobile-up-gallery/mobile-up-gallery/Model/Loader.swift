//
//  Loader.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 01.04.2022.
//

import Alamofire

final class Loader {
    static func loadData(
        url: URLConvertible,
        completion: @escaping (Result<Data, ErrorType>) -> Void
    ) {
        AF.download(url)
            .validate()
            .responseData { response in
                if let data = response.value {
                    completion(.success(data))
                } else {
                    completion(.failure(.serverError))
                }
            }
    }
}
