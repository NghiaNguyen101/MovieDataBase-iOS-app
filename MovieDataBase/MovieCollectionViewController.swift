//
//  MovieCollectionViewController.swift
//  
//
//  Created by Nghia Nguyen on 5/13/17.
//
//

import UIKit
import AlamofireImage
import MBProgressHUD

class MovieCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var networkErrButton : UIButton?
    var movies : [[String:Any]] = []
    var filterMovies : [[String:Any]] = []
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        // Network error button
        networkErrButton = UIButton(frame: CGRect(x: collectionView.bounds.origin.x, y: collectionView.bounds.origin.y, width: collectionView.bounds.width, height: searchBar.bounds.height))
        networkErrButton?.backgroundColor = UIColor.gray
        networkErrButton?.setTitle("Network Error!", for: .normal)
        networkErrButton?.isEnabled = true
        networkErrButton?.isHidden = false
        networkErrButton?.addTarget(self, action: #selector(fetch_data), for: UIControlEvents.touchUpInside)
        collectionView.addSubview(networkErrButton!)
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(update_data(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to collection view
        collectionView.insertSubview(refreshControl, at: 0)
        
        //fetch_data()
    }
    
    func update_data(_ refreshControl: UIRefreshControl) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(self.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // Hide HUD once the network request comes back (must be done on main UI thread)
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [[String:Any]]
                    self.filterMovies = self.movies
                    print(self.movies)
                    self.collectionView.reloadData()
                    self.networkErrButton?.isHidden = true
                }
            } else {
                self.networkErrButton?.isHidden = false
            }
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    func fetch_data() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(self.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // Hide HUD once the network request comes back (must be done on main UI thread)
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [[String:Any]]
                    self.filterMovies = self.movies
                    print(self.movies)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.collectionView.reloadData()
                    self.networkErrButton?.isHidden = true
                }
            } else {
                self.networkErrButton?.isHidden = false
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterMovies.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: self.view.bounds.width/2, height: 250)
        let movie = self.filterMovies[indexPath.row]
        if let poster_path = movie["poster_path"] as? String {
            let base_url = "https://image.tmdb.org/t/p/w500/"
            let poster_url = URL(string: base_url + poster_path)
            cell.movieImage.alpha = 0.0
            cell.movieImage.af_setImage(withURL: poster_url!)
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                cell.movieImage.alpha = 1.0
            })
        } else {
            cell.movieImage.image = nil
        }
        
        return cell
    }
    
    // MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMovies = searchText.isEmpty ? movies : movies.filter {
            (item: [String: Any]) -> Bool in
            let title = item["title"] as! String
            return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        filterMovies = movies
        collectionView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
