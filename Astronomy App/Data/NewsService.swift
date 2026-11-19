//
//  NewsService.swift
//  Astronomy App
//
//  Created by Ana Soares on 12/11/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidImage
    case emptyResult
    case badStatus(Int)
    case decoding(Error)
}

struct NewsService {
    
    static let poolsize = 5000
    static let windowStart = "2025-01-01T00:00:00Z"
    static let windowEnd   = "2025-12-31T23:59:59Z"
    static let minSummaryLength = 300
    
    func fetchLatestArticles(limit: Int = 10) async throws -> [Article] {
        //destrinchando a URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spaceflightnewsapi.net"
        components.path = "/v4/articles/"
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        guard let url = components.url else {throw NetworkError.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {throw NetworkError.invalidResponse}
        guard (200...299).contains(http.statusCode) else { throw NetworkError.badStatus(http.statusCode) }
        
        do{
            let decoded = try JSONDecoder().decode(ArticleResponse.self, from: data)
            return decoded.results
        } catch{
            throw NetworkError.decoding(error)
        }
        
    }
    
    func fetchArticles(atOffset offset: Int, limit: Int) async throws -> [Article] {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spaceflightnewsapi.net"
        components.path = "/v4/articles/"
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "ordering", value: "published_at"),
            URLQueryItem(name: "published_at_gte", value: NewsService.windowStart),
            URLQueryItem(name: "published_at_lte", value: NewsService.windowEnd)
        ]
        
        guard let url = components.url else {throw NetworkError.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {throw NetworkError.invalidResponse}
        guard (200...299).contains(http.statusCode) else {
            print("Corpo do erro:", String(data: data, encoding: .utf8) ?? "vazio")
            throw NetworkError.badStatus(http.statusCode)
        }
        
        let decoded: ArticleResponse
        
        do{
            decoded = try JSONDecoder().decode(ArticleResponse.self, from: data)
            
        } catch{
            
            throw NetworkError.decoding(error)
        }
        
//        guard let article = decoded.results.first else { throw NetworkError.emptyResult }
        
        return decoded.results
        
    }
    
    func fetchArticle(forSeed seed: Int) async throws -> Article {
        
        let offset = DailySeed.offset(forSeed: seed, poolsize: NewsService.poolsize)
        let batch = try await fetchArticles(atOffset: offset, limit: 20)
        
        guard let article = batch.first(where: {
            $0.summary.trimmingCharacters(in: .whitespacesAndNewlines).count >= NewsService.minSummaryLength
        }) else {
            throw NetworkError.emptyResult
        }
        
        return article
        
    }
    
}
