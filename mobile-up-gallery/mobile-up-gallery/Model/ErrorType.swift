//
//  ErrorType.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 01.04.2022.
//

import Foundation

enum ErrorType: String, Error {
    case noConnection
    case appError
    case serverError
    case unknownError
    case closingAuthenticationWindow

    var title: String {
        Bundle.main.localizedString(forKey: rawValue,
                                    value: titleDefaultValue,
                                    table: "AllertTitleLocolizable")
    }

    var message: String {
        Bundle.main.localizedString(forKey: rawValue,
                                    value: messageDefaultValue,
                                    table: "AllertMessageLocolizable")
    }

    var titleDefaultValue: String {
        switch self {
        case .noConnection:
            return "No connection"
        case .appError:
            return "Hmmm."
        case .serverError:
            return "Server Error"
        case .unknownError:
            return "Unknown Error"
        case .closingAuthenticationWindow:
            return "Closing the authentication window"
        }
    }

    var messageDefaultValue: String {
        switch self {
        case .noConnection:
            return "No internet connection or connection to VK service"
        case .appError:
            return "Most likely, this is an application error"
        case .serverError:
            return "It's look like server error"
        case .unknownError:
            return "Try restarting the app"
        case .closingAuthenticationWindow:
            return "You closed the authentication window before the process ended"
        }
    }
}
