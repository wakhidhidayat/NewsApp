//
//  ViewController.swift
//  News App
//
//  Created by Wahid Hidayat on 28/01/21.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    
    var newsDatas = [News]()
    var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        newsTable.backgroundView = activityIndicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "News"
        fetchNews()
        
        newsTable.register(NewsTableViewCell.nib(), forCellReuseIdentifier: NewsTableViewCell.identifier)
        newsTable.delegate = self
        newsTable.dataSource = self
    }
    
    func fetchNews() {
        activityIndicator.startAnimating()
        newsTable.separatorStyle = .none

        URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=id&apiKey=2169e45c9cec490b9aaed732d6090a7b")!, completionHandler: { data, response, error in
            
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: newsDatas[indexPath.row])
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = SFSafariViewController(url: URL(string: newsDatas[indexPath.row].url)!)
        present(vc, animated: true)
    }
}
