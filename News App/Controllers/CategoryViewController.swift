//
//  CategoryViewController.swift
//  News App
//
//  Created by Wahid Hidayat on 29/01/21.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    let categories = ["bussiness","entertainment","health","science","technology","sports","id","us"]
    
    override func viewDidLoad() {
        self.navigationItem.title = "Category"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detail.category = categories[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
