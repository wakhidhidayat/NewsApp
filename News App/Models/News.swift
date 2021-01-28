//
//  News.swift
//  News App
//
//  Created by Wahid Hidayat on 28/01/21.
//

import UIKit

struct NewsResult: Codable {
    var articles: [News]
}

struct News: Codable {
    var title: String
    var url: String
    var urlToImage: String
    var source: Source
    
    struct Source: Codable {
        var name: String
    }
}
