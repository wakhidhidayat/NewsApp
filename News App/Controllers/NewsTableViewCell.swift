//
//  NewsTableViewCell.swift
//  News App
//
//  Created by Wahid Hidayat on 28/01/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "NewsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsTableViewCell", bundle: nil)
    }
    
    func configure(with model: News) {
        self.title.text = model.title
        self.date.text = model.publishedAt
        self.source.text = model.source.name
        
        if let data = try? Data(contentsOf: URL(string: model.urlToImage)!) {
            self.poster.image = UIImage(data: data)
        }
    }
    
}
