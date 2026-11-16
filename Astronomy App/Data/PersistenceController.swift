//
//  PersistanceController.swift
//  Astronomy App
//
//  Created by Ana Soares on 16/11/26.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceController{
    
    let container: ModelContainer
    
    init() {
        do {
            
            container = try ModelContainer(for: StoredArticle.self)
            
        } catch {
            
            fatalError("Não foi possivel criar o model container \(error)" )
            
        }
    }
    
    var context: ModelContext{
        container.mainContext
    }
    
}
