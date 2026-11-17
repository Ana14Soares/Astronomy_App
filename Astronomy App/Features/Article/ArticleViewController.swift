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
    
    private let articleView = ArticleView()
    private var currentArticle: StoredArticle?
    
    override func loadView() {
        view = articleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleView.onOpenLink = { [weak self] in self?.openArticle() }
        articleView.onRetry    = { [weak self] in self?.loadContent() }
        
        loadContent()
        updateFavoriteButton()
        
    }
    
    private func loadContent(){
        articleView.render(.loading)
        Task {
            do {
                let article = try await repository.article(forSeed: seed)
                currentArticle = article
                updateFavoriteButton()
                articleView.render(.loaded(article, image(for: article)))
            } catch {
                articleView.render(.failed("Could not load the article"))
                print("Erro:", error)
            }
        }
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: action)
        navigationItem.rightBarButtonItem?.isEnabled = (currentArticle != nil)
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

