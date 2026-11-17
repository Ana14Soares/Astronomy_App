//
//  ArticleView.swift
//  Astronomy App
//
//  Created by Ana Soares on 17/11/26.
//

import Foundation
import UIKit

final class ArticleView: UIView {
    
    var onOpenLink: (() -> Void)?
    var onRetry: (() -> Void)?
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let sourceLabel = UILabel()
    private let summaryLabel = UILabel()
    private let linkButton = UIButton(type: .system)
    private let spinner = UIActivityIndicatorView(style: .large)

   
    private lazy var stack = UIStackView(arrangedSubviews: [
        imageView, titleLabel, sourceLabel, summaryLabel, linkButton
    ])
    
    private lazy var errorStack = UIStackView(arrangedSubviews: [errorLabel, retryButton])
    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setupLayout()
        setupStyles()
        setupOverlays()
        render(.loading)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) não é usado") }
    
    private func setupLayout(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
        stack.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(stack)
        
        let safeArea = safeAreaLayoutGuide

        
        NSLayoutConstraint.activate([
            // a janela ocupa a tela toda
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            // o conteúdo define o tamanho rolável
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // largura = largura da janela (só rola na vertical)
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

          
            imageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func setupStyles(){
        
        //titleLabel
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .label
        
        //summaryLabel
        summaryLabel.numberOfLines = 0
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .light)
        summaryLabel.adjustsFontForContentSizeCategory = true
        summaryLabel.textColor = .label
        
        //sourceLabel
        sourceLabel.numberOfLines = 0
        sourceLabel.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .medium)
        sourceLabel.adjustsFontForContentSizeCategory = true
        sourceLabel.textColor = .secondaryLabel
        
        //imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        //linkButton
        var config = UIButton.Configuration.filled()
        config.title = "Read full article"
        config.imagePadding = 8
        linkButton.configuration = config
        linkButton.addAction(UIAction { [weak self] _ in self?.onOpenLink?() }, for: .touchUpInside)
        
    }
    
    private func setupOverlays() {
        // spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)

        // erro
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.textColor = .secondaryLabel
        errorLabel.font = UIFont.preferredFont(forTextStyle: .body)
        errorLabel.adjustsFontForContentSizeCategory = true

        var retryConfig = UIButton.Configuration.bordered()
        retryConfig.title = "Try again"
        retryButton.configuration = retryConfig
        retryButton.addAction(UIAction { [weak self] _ in self?.onRetry?() }, for: .touchUpInside)

        errorStack.axis = .vertical
        errorStack.spacing = 16
        errorStack.alignment = .center
        errorStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorStack)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            errorStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorStack.leadingAnchor.constraint(greaterThanOrEqualTo: safeArea.leadingAnchor, constant: 24),
            errorStack.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -24)
        ])

        // começam escondidos: quem decide é o render(_:)
        errorStack.isHidden = true
    }
    
    func render(_ state: LoadStatus) {

        // 1) começa com tudo desligado
        scrollView.isHidden = true
        errorStack.isHidden = true
        spinner.stopAnimating()

        // 2) cada estado liga só o que é seu
        switch state {

        case .loading:
            spinner.startAnimating()

        case .loaded(let article, let image):
            titleLabel.text = article.title
            sourceLabel.text = article.newsSite
            summaryLabel.text = article.summary
            imageView.image = image
            scrollView.isHidden = false

        case .failed(let message):
            errorLabel.text = message
            errorStack.isHidden = false
        }
    }
    
}
