//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Mohit Goenka on 9/9/14.
//  Copyright (c) 2014 mgoenka. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var announcementView: UIView!
    @IBOutlet weak var searchTabBar: UISearchBar!
    @IBOutlet weak var networkError: UILabel!

    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.networkError.hidden = true
        self.searchTabBar.hidden = false

        var progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Loading..."
        progressHUD.show(true)
        
        var url = self.navigationItem.title == "Movies" ? "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us" : "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.networkError.hidden = false
                self.searchTabBar.hidden  = true
            } else {
                self.networkError.hidden = true
                self.searchTabBar.hidden = false
                var objects = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                self.movies = objects["movies"] as [NSDictionary]
                self.tableView.reloadData()
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var posterDictionary = movie["posters"] as NSDictionary
        var posterUrl = posterDictionary["thumbnail"] as String
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let indexPath = tableView.indexPathForSelectedRow()
        var movie = movies[indexPath!.row]
        var movieName = movie["title"] as? String
        var textdesc = movie["synopsis"] as? String
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["original"] as String
        
        if (segue.identifier == "movieSegue") {
            let detailViewController = segue.destinationViewController as DetailViewController
            detailViewController.posterUrl  = posterUrl
            detailViewController.descriptionText = textdesc!
            detailViewController.movieName = movieName!
        }
    }
}
