//
//  ViewController.swift
//  Astronomy App
//
//  Created by Ana Soares on 10/11/26.
//

import UIKit
import SafariServices

final class ArticleViewController: UIViewController {
    
    var repository: ArticleRepository!
    var seed: Int = DailySeed.seed(for: Date())
    var preloadedArticle: StoredArticle?
    
    private let articleView = ArticleView()
    private var currentArticle: StoredArticle?
    
    private var displaySeed: Int? {
        preloadedArticle?.dailySeed ?? seed
    }
    
    override func loadView() {
        view = articleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleView.onOpenLink = { [weak self] in self?.openArticle() }
        articleView.onRetry    = { [weak self] in self?.loadContent() }
        
        if let displaySeed {
            title = DateText.title(forSeed: displaySeed)
        }
        loadContent()
        updateFavoriteButton()
        
    }
    
    private func loadContent(){
        articleView.render(.loading)
        
        if let article = preloadedArticle {
            show(article)
            return
        }
        
        Task {
            do {
                
                let article = try await repository.article(forSeed: seed)
                show(article)
                
            } catch {
                articleView.render(.failed("Could not load the article"))
                print("Erro:", error)
            }
        }
    }
    
    private func show(_ article: StoredArticle) {
        currentArticle = article
        updateFavoriteButton()
        articleView.render(.loaded(article, image(for: article)))
    }
    
    private func image(for article: StoredArticle) -> UIImage? {
        guard let data = article.imageData else { return nil }
        return UIImage(data: data)
    }
    
    private func openArticle() {
        guard let url = currentArticle?.url else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
    
    private func updateFavoriteButton(){
        let isFavorite = currentArticle?.isFavorite ?? false
        let symbol = isFavorite ? "star.fill" : "star"
        let action = UIAction(image: UIImage(systemName: symbol)) { [weak self] _ in
            self?.favoriteTapped()
        }
        
        let item = UIBarButtonItem(primaryAction: action)
            item.tintColor = .systemBlue
            item.isEnabled = (currentArticle != nil)

            navigationItem.rightBarButtonItem = item
    }
    
    private func favoriteTapped(){
        
        guard let article = currentArticle else { return }
        
        do {
            try repository.toggleFavorite(article: article)
            updateFavoriteButton()
        } catch {
            print("Erro ao favoritar:", error)
        }
        
    }
    
}

