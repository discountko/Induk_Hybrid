//
//  MovieModel.swift
//  Basic
//
//  Created by pineone on 2022/04/14.
//

import UIKit

// MARK: - MovieResponse 공통 리스폰스
struct MovieResponse: Codable {
    let status, statusMessage: String
    let data: MovieListModel // Any
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case data
        case meta = "@meta"
    }
}

// MARK: - MovieListModel
struct MovieListModel: Codable {
    let movieCount, limit, pageNumber: Int
    let movieList: [Movie]

    enum CodingKeys: String, CodingKey {
        case movieCount = "movie_count"
        case limit
        case pageNumber = "page_number"
        case movieList = "movies"
    }
}

struct Movie: Codable {
    let id: Int
    let url: String
    let imdbCode, title, titleEnglish, titleLong: String
    let slug: String
    let year: Int
    let rating: Double
    let runtime: Int
    let genres: [String]
    let summary, descriptionFull, synopsis, ytTrailerCode: String
    let language, mpaRating: String
    let backgroundImage, backgroundImageOriginal, smallCoverImage, mediumCoverImage: String
    let largeCoverImage: String
    let state: String
    let torrents: [Torrent]
    let dateUploaded: String
    let dateUploadedUnix: Int

    enum CodingKeys: String, CodingKey {
        case id, url
        case imdbCode = "imdb_code"
        case title
        case titleEnglish = "title_english"
        case titleLong = "title_long"
        case slug, year, rating, runtime, genres, summary
        case descriptionFull = "description_full"
        case synopsis
        case ytTrailerCode = "yt_trailer_code"
        case language
        case mpaRating = "mpa_rating"
        case backgroundImage = "background_image"
        case backgroundImageOriginal = "background_image_original"
        case smallCoverImage = "small_cover_image"
        case mediumCoverImage = "medium_cover_image"
        case largeCoverImage = "large_cover_image"
        case state, torrents
        case dateUploaded = "date_uploaded"
        case dateUploadedUnix = "date_uploaded_unix"
    }
}

// MARK: - Torrent
struct Torrent: Codable {
    let url: String
    let hash, quality, type: String
    let seeds, peers: Int
    let size: String
    let sizeBytes: Int
    let dateUploaded: String
    let dateUploadedUnix: Int

    enum CodingKeys: String, CodingKey {
        case url, hash, quality, type, seeds, peers, size
        case sizeBytes = "size_bytes"
        case dateUploaded = "date_uploaded"
        case dateUploadedUnix = "date_uploaded_unix"
    }
}


// MARK: - Meta
struct Meta: Codable {
    let serverTime: Int
    let serverTimezone: String
    let apiVersion: Int
    let executionTime: String

    enum CodingKeys: String, CodingKey {
        case serverTime = "server_time"
        case serverTimezone = "server_timezone"
        case apiVersion = "api_version"
        case executionTime = "execution_time"
    }
}
