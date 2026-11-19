//
//  FavoritesViewController.swift
//  Astronomy App
//
//  Created by Ana Soares on 17/11/26.
//

import Foundation
import UIKit

final class FavoritesViewController: UITableViewController {
    
    var repository: ArticleRepository!
    private var articles: [StoredArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articles = (try? repository.favorites()) ?? []
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = article.title
        content.textProperties.numberOfLines = 2
        if let seed = article.dailySeed {
            content.secondaryText = DateText.short(fromSeed: seed)
        }
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detail = ArticleViewController()
        detail.repository = repository
        detail.preloadedArticle = articles[indexPath.row]

        navigationController?.pushViewController(detail, animated: true)
    }
    
}
