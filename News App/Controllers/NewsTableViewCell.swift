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
        self.poster.layer.cornerRadius = 10
        self.poster.clipsToBounds = true
        
        self.title.text = model.title
        
        if let dateTime = model.publishedAt.convertDateString() {
            self.date.text = "\u{2022} \(dateTime.timeAgoDisplay())"
        }
        
        self.source.text = model.source.name
        
        if let data = try? Data(contentsOf: URL(string: model.urlToImage)!) {
            self.poster.image = UIImage(data: data)
        }
    }
}

extension String {
    func convertDateString() -> Date? {
        return convert(dateString: self, fromDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ", toDateFormat: "dd-MM-yyyy")
    }

    func convert(dateString: String, fromDateFormat: String, toDateFormat: String) -> Date? {

        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromDateFormat

        if let fromDateObject = fromDateFormatter.date(from: dateString) {

            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = toDateFormat

            return fromDateObject
        }

        return nil
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

