//
//  NetworkService.swift
//  Basic
//
//  Created by pineone on 2022/04/14.
//

import Foundation
import RxCocoa
import RxSwift
import Moya


struct NetworkService {
    static func movieList(limit: Int?, page: Int?, minimumRating: Int?) -> Single<MovieListModel> {
        return APIClient.request(.movie_list(limit: limit, page: page, minimum_rating: minimumRating))
    }
    
}
