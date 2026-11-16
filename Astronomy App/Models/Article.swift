//
//  Article.swift
//  Astronomy App
//
//  Created by Ana Soares on 12/11/26.
//

import Foundation

struct Article: Decodable, Identifiable, Hashable {
    
    let id: Int
    let title: String
    let url: URL
    let imageUrl: URL?
    let newsSite: String
    let summary: String
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case url = "url"
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary = "summary"
        case publishedAt = "published_at"
        
    }
}

struct ArticleResponse: Decodable {
    let results: [Article]
}


