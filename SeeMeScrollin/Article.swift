//
//  Article.swift
//  SeeMeScrollin
//
//  Created by Jordan Carlson on 4/17/17.
//  Copyright © 2017 savagej. All rights reserved.
//

import Foundation

struct Article {
    let textInfo: String
    var isExpanded: Bool
    
    init(textInfo: String, isExpanded: Bool) {
        self.textInfo = textInfo
        self.isExpanded = isExpanded
    }
    
    static func importArticles() -> [Article] {
        
        var articles = [Article]()
        
        guard let url = Bundle.main.url(forResource: "articles", withExtension: "json") else {
            return articles
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                return articles
            }
            
            guard let articleObjects = rootObject["articles"] as? [[String: AnyObject]] else {
                return articles
            }
            
            for articleObject in articleObjects {
                if let textInfo = articleObject["textInfo"] as? String {
                    let article = Article(textInfo: textInfo, isExpanded: false)
                    articles.append(article)
                }
            }
        } catch {
            return articles
        }
        return articles
    }
}
