//
//  ArticleTableViewController.swift
//  SeeMeScrollin
//
//  Created by Jordan Carlson on 4/17/17.
//  Copyright © 2017 savagej. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireRSSParser

class ArticleTableViewController: UITableViewController {

    var articles = Article.importArticles()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func loadFakeData(_ sender: Any) {
        self.articles = Article.importArticles()
        tableView.reloadData()
    }

    @IBAction func loadRSSFeed(_ sender: Any) {
        Alamofire.request("http://rss.cnn.com/rss/cnn_topstories.rss").responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.result.value {
                var newArticles = [Article]()
                for item in feed.items {
                    let article = Article(textInfo: item.title! as String, isExpanded: false)
                    newArticles.append(article)
                }
                self.articles.removeAll()
                self.articles.insert(contentsOf: newArticles, at: 0)
                    
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        
        cell.textPreview.numberOfLines = 3
        cell.textPreview.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        cell.textPreview.text = article.textInfo

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell else { return }
        
        var article = articles[indexPath.row]
        
        article.isExpanded = !article.isExpanded
        articles[indexPath.row] = article
        
        cell.textPreview.numberOfLines = article.isExpanded ? 0 : 3
        
        if !article.isExpanded {
            cell.textPreview.lineBreakMode = NSLineBreakMode.byTruncatingTail
        }
        
        cell.selectionStyle = .none
        
        tableView.beginUpdates()
        tableView.endUpdates()
                
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - tableView.frame.size.height
        if actualPosition >= contentHeight {
            self.articles.append(contentsOf: self.articles)
            tableView.reloadData()
        } else if actualPosition <= 0 {
            var reversed = Array(articles.reversed())
            _ = reversed.removeFirst()
            self.articles.insert(contentsOf: reversed, at: 0)
            tableView.reloadData()
            tableView.contentOffset.y += 9 * 125.5
        }
    }

}
