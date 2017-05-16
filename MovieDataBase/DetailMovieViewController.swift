//
//  DetailMovieViewController.swift
//  MovieDataBase
//
//  Created by Nghia Nguyen on 5/14/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailMovieViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailView.layer.cornerRadius = 15
        
        let title = movie["title"] as? String
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        let release_date_str = movie["release_date"] as! String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let release_date = formatter.date(from: release_date_str)
        formatter.dateFormat = "MMMM dd, yyyy"
        releaseDateLabel.text = formatter.string(from: release_date!)
        releaseDateLabel.sizeToFit()
        
        let rating = movie["vote_average"] as? Double
        ratingLabel.text = "Rating: " + String(describing: rating!)
        ratingLabel.sizeToFit()
        
        detailView.sizeToFit()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + detailView.frame.size.height + 20)
        
        if let poster_path = movie["poster_path"] as? String {
            let base_url = "https://image.tmdb.org/t/p/w500/"
            let poster_url = URL(string: base_url + poster_path)
            posterImage.af_setImage(withURL: poster_url!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
