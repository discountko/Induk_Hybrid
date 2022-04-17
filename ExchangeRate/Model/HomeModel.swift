//
//  HomeModel.swift
//  Basic
//
//  Created by pineone on 2021/11/08.
//

import Foundation

/// 앱 정보
struct HomeModel: Codable {
    /// 앱 이미지 URL
    let appImageUrl: String?
    /// 앱 이름
    let appName: String?
    /// 자녀가 설치한 앱 버전
    let apppVersion: String?
    /// 앱 정보
    let appDesc: String?
}

/// 앱 평가
struct ReviewModel: Codable {
    let peopleCount: Int
}

/// 리뷰
struct RatingModel: Codable {
    let reviewCount: Int
    
    let reviewData: [Reviews]
}

struct Reviews: Codable {
    let name: String
    
    let children: String
    
    let desc: String
    
    let writeDay: String
}
