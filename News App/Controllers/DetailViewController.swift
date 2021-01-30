//
//  DetailViewController.swift
//  News App
//
//  Created by Wahid Hidayat on 30/01/21.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    
    var category: String?
    var newsDatas = [News]()
    var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        newsTable.backgroundView = activityIndicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var title = category?.capitalized
        if category == "id" {
            title = "Trend in Indonesia"
        } else if category == "us" {
            title = "Trend in US"
        }
        self.navigationItem.title = title
        
        fetchNews()
        
        newsTable.register(NewsTableViewCell.nib(), forCellReuseIdentifier: NewsTableViewCell.identifier)
        newsTable.delegate = self
        newsTable.dataSource = self
    }
    
    func fetchNews() {
        activityIndicator.startAnimating()
        newsTable.separatorStyle = .none

        guard let category = category else {
            return
        }
        
        var endpoint = "https://newsapi.org/v2/top-headlines?country=id&category=\(category)&apiKey=\(Secrets.apiKey)"
        
        if category == "us" || category == "id" {
            endpoint = "https://newsapi.org/v2/top-headlines?country=\(category)&apiKey=\(Secrets.apiKey)"
        }
        
        URLSession.shared.dataTask(with: URL(string: endpoint)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            var result: NewsResult?
            
            do {
                result = try JSONDecoder().decode(NewsResult.self, from: data)
            } catch {
                print("Error when parsing news")
            }
            
            guard let finalResult = result else {
                return
            }
            
            let articles = finalResult.articles
            self.newsDatas.append(contentsOf: articles)
            
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.newsTable.separatorStyle = .singleLine
                self.newsTable.reloadData()
            }
        }).resume()
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: newsDatas[indexPath.row])
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = SFSafariViewController(url: URL(string: newsDatas[indexPath.row].url)!)
        present(vc, animated: true)
    }
}
