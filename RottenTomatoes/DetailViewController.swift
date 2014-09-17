//
//  DetailViewController.swift
//  RottenTomatoes
//
//  Created by Mohit Goenka on 9/15/14.
//  Copyright (c) 2014 mgoenka. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UINavigationItem!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!

    var movieName = ""
    var posterUrl = ""
    var descriptionText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.title = movieName
        posterImage.setImageWithURL(NSURL(string: posterUrl))
        synopsisLabel.text = descriptionText
        synopsisLabel.sizeToFit()
        scrollView.contentSize.height   = 320 + contentView.frame.size.height
        scrollView.contentSize.width = 320
        contentView.addSubview(synopsisLabel)
        scrollView.addSubview(contentView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
