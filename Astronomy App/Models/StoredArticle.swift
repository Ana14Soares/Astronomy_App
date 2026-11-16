//
//  StoredArticle.swift
//  Astronomy App
//
//  Created by Ana Soares on 13/11/26.
//

import Foundation
import SwiftData

@Model

final class StoredArticle {
    
    @Attribute(.unique) var id: Int
    var title: String
    var summary: String
    var url: URL
    var imageUrl: URL?
    var newsSite: String
    var publishedAt: String
    var isFavorite: Bool
    var note: String
    var dailySeed: Int?
    
    init(
        id: Int,
        title: String,
        summary: String,
        url: URL,
        imageUrl: URL?,
        newsSite: String,
        publishedAt: String,
        isFavorite: Bool = false,
        note: String = "",
        dailySeed: Int? = nil
    ){
        self.id = id
        self.title = title
        self.summary = summary
        self.url = url
        self.imageUrl = imageUrl
        self.newsSite = newsSite
        self.publishedAt = publishedAt
        self.isFavorite = isFavorite
        self.note = note
        self.dailySeed = dailySeed
    }
    
    convenience init(from article: Article, dailySeed: Int? = nil) {
        self.init(
            id: article.id,
            title: article.title,
            summary: article.summary,
            url: article.url,
            imageUrl: article.imageUrl,
            newsSite: article.newsSite,
            publishedAt: article.publishedAt,
            dailySeed: dailySeed
        )
    }
    
}
