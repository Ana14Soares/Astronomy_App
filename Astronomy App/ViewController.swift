//
//  ViewController.swift
//  Astronomy App
//
//  Created by Ana Soares on 10/11/26.
//

import UIKit
import SwiftData

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let sourceLabel = UILabel()
    let summaryLabel = UILabel()
    
    var context: ModelContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupImageView()
        setupLabels()
        loadContent()

    }

    private func loadContent(){
        Task {
            do {
                let article = try await NewsService().fetchArticle(for: Date())
                print(article.title)
                print(article.url)
                print(article.summary)
                
                
                let stored = StoredArticle(from: article, dailySeed: DailySeed.seed(for: Date()))
                context.insert(stored)
                try context.save()

                let all = try context.fetch(FetchDescriptor<StoredArticle>())
                print("Guardados:", all.count)
                
                titleLabel.text = article.title
                sourceLabel.text = article.url.absoluteString
                summaryLabel.text = article.summary
                
                if let imageUrl = article.imageUrl {
                    imageView.image = try? await ImageLoader().loadImage(from: imageUrl)
                    
                } else {
                    imageView.image = nil
                    
                }
                
            } catch {
                print("Erro:", error)
            }
        }
    }
    
    private func setupImageView(){
        
        view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
    }
    
    private func setupLabels(){
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .black
        
        summaryLabel.numberOfLines = 0
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .light)
        summaryLabel.adjustsFontForContentSizeCategory = true
        summaryLabel.textColor = .black
        
        sourceLabel.numberOfLines = 0
        sourceLabel.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .medium)
        sourceLabel.adjustsFontForContentSizeCategory = true
        sourceLabel.textColor = .black
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, summaryLabel, sourceLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24)
        ])
        
    }
    
}

