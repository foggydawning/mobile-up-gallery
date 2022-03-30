//
//  AuthViewControllerDelegate.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 30.03.2022.
//

protocol AuthViewControllerDelegate: AnyObject {
    func saveToken(token: String)
}
