//
//  Model.swift
//  Basic
//
//  Created by pineone on 2021/10/05.
//

/// 테스트 페이지

import Foundation

struct UsersModel: Decodable {
    let login: String?
    let avatar_url: String?
    let html_url: String?
    
    let items: [SearchList]?
    
    let update: Owner?
    
    init(_ item: UsersModel) {
        login = item.login
        avatar_url = item.avatar_url
        html_url = item.html_url
        items = item.items
        update = item.update
    }
}

struct SearchList: Decodable {
    let id: Int?
    let name: String?
    let full_name: String?
    
    let html_url: String?
    let description: String?
    

    let stargazers_count: Int?
    let language: String?
}

struct Owner: Decodable {
    let login: String?
    let url: String?
    let html_url: String?
}
