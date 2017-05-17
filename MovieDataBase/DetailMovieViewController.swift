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
        
        detailView.frame.size.height = titleLabel.frame.size.height + 70 + releaseDateLabel.frame.size.height + overviewLabel.frame.size.height
//        detailView.sizeToFit()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + detailView.frame.size.height + 20)
        
        // Load small image first then large image
        if let poster_path = movie["poster_path"] as? String {
            let base_url = "https://image.tmdb.org/t/p/w500/"
            let poster_url = URL(string: base_url + poster_path)
            let original_base_url = "https://image.tmdb.org/t/p/original"
            let original_poster_url = URL(string: original_base_url + poster_path)
            let smallImageRequest = URLRequest(url: poster_url!)
            let largeImageRequest = URLRequest(url: original_poster_url!)
            
            posterImage.setImageWith(smallImageRequest, placeholderImage: nil, success: {(smallImageRequest, smallImageResponse, smallImage) -> Void in
                var duration = 0.0
                if smallImageResponse != nil {
                    self.posterImage.alpha = 0.0
                    duration = 0.3
                }
                self.posterImage.image = smallImage
                UIView.animate(withDuration: duration, animations: { () -> Void in
                    self.posterImage.alpha = 1.0
                }, completion: { (success) -> Void in
                    self.posterImage.setImageWith(largeImageRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageReponse, largeImage) -> Void in
                        self.posterImage.image = largeImage
                    }, failure: { (request, reponse, error) -> Void in
                        // handle err, but most likely just leave it
                    })
                })
            }, failure: { (smallImageRequest, smallImageResponse, error) -> Void in
                self.posterImage.image = nil
            })
        } else {
            posterImage.image = nil
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
