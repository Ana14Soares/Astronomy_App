//
//  ArticleRepository.swift
//  Astronomy App
//
//  Created by Ana Soares on 16/11/26.
//

import Foundation
import SwiftData

@MainActor
final class ArticleRepository {
    
    private let context: ModelContext
    private let service: NewsService

    init(context: ModelContext, service: NewsService = NewsService()) {
        self.context = context
        self.service = service
    }
    
    func article(forSeed seed: Int) async throws -> StoredArticle {
        
        
        let descriptor = FetchDescriptor<StoredArticle>(
            predicate: #Predicate { $0.dailySeed == seed }
        )
        
        if let found = try context.fetch(descriptor).first{
            await ensureImage(for: found)
            return found
        }
        
        let article = try await service.fetchArticle(forSeed: seed)
        
        //verificando se o id ja existe no banco
        let articleId = article.id
        let byId = FetchDescriptor<StoredArticle>(
            predicate: #Predicate { $0.id == articleId }
        )
        
        let stored: StoredArticle
        if let existing = try context.fetch(byId).first {
            // reaproveita: só marca de qual dia ele é
            existing.dailySeed = seed
            stored = existing
        } else {
            // cria um novo
            stored = StoredArticle(from: article, dailySeed: seed)
            context.insert(stored)
        }

        await ensureImage(for: stored)
        try context.save()
        return stored
        
    }
    
    func toggleFavorite(article: StoredArticle) throws {
        
        article.isFavorite.toggle()
        try context.save()
        
    }
    
    func cleanUp(keepingSeed todaySeed: Int) throws {
        
        let descriptor = FetchDescriptor<StoredArticle>(
            predicate: #Predicate {
                $0.isFavorite == false && ($0.dailySeed == nil || $0.dailySeed != todaySeed)
            }
        )
        
        let toDelete = try context.fetch(descriptor)
        for article in toDelete{
            context.delete(article)
        }
        
        try context.save()
        
    }
    
    private func ensureImage(for article: StoredArticle) async {
        guard article.imageData == nil,
              let url = article.imageUrl else { return }

        article.imageData = try? await ImageLoader().loadData(from: url)
        try? context.save()
    }
    
}
