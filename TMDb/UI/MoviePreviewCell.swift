//
//  MoviePreviewCell.swift
//  TMDb
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import UIKit

class MoviePreviewCell: UITableViewCell {
    
    var urlTag: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    override func prepareForReuse() {
        activityIndicator.stopAnimating()
        poster.image = nil
        title.text = ""
        overview.text = ""
    }
    
}
