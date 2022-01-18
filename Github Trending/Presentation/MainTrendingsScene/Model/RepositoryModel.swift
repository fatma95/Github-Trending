//
//  Repository.swift
//  Github Trending
//
//  Created by Fatma Mohamed on 16/01/2022.
//

import Foundation

struct RepositoryResponse: Codable {
    let repositoryModel: [Repository]
}

struct Repository: Codable {
    let rank: Int
    let username, repositoryName: String
    let url: String
    let welcomeDescription, language, languageColor: String?
    let totalStars, forks, starsSince: Int
    let since: Since
    let builtBy: [BuiltBy]

    enum CodingKeys: String, CodingKey {
        case rank, username, repositoryName, url
        case welcomeDescription = "description"
        case language, languageColor, totalStars, forks, starsSince, since, builtBy
    }
}

// MARK: - BuiltBy
struct BuiltBy: Codable {
    let username: String
    let url, avatar: String
}

enum Since: String, Codable {
    case daily = "daily"
}
