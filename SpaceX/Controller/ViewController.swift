//
//  ViewController.swift
//  SpaceX
//
//  Created by Get My Parking on 02/02/22.
//

import UIKit
import Lottie

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    
    var aView = UIView()
    var refreshControl = UIRefreshControl()
    
//    Table data store in that Array
    var rockets = [AllRocketData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Hide the searchBar and head text
        name.text = ""
        searchBar.isHidden = true
        
//        call function for animation
        self.AnimationDone()
    }
    
    func loadData(completion: @escaping ()->()) {
        ProcessingRequest().fetchLaunches(senderObject: self) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                completion()
            }
        }
    }
    
    
    @objc func refresh(sender: UIRefreshControl) {
        loadData() {
            
//            Stop refresh loading after table reload
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func filterButton(_ sender: UIButton) {
        var successRocket = [AllRocketData]()
        for check in rockets {
            if check.success == true {
                successRocket.append(check)
            }
        }
        rockets = successRocket
        tableView.reloadData()
    }
        
}
    


//Performing task related to tableView

extension ViewController {
    
    
    func completion() {
        
//        Show loading until table reload
        showLoadingIndicator()
        
//        Assign the pull to refres
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "rocketLaunch")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.filterButton.setImage(UIImage(named: "filter"), for: .normal)
        
//        Load the table data
        loadData() {
            
//            Stop loading after table reload
            self.stopLoadingIndicator()
        }
    }
    
//    Perform sague after selecting the row of table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DetailsViewController.rocketId = rockets[indexPath.row].id
        performSegue(withIdentifier: "goToDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    Return the no. of cell in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rockets.count
    }
    
//    Assign the text in table cell and success or failure indication
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rocketLaunch", for: indexPath)
        cell.textLabel?.text = rockets[indexPath.row].name
        
        let result = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        result.image = rockets[indexPath.row].success == true ? UIImage(named: "success") : UIImage(named: "failure")
//        cell.imageView?.image = UIImage(named: "filter")
        cell.accessoryView = result
        
        return cell
    }
    
}


extension ViewController: UISearchBarDelegate {
    
//    Function for searching
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var tempSearch = [AllRocketData]()
        for rocket in rockets {
            if rocket.name.localizedCaseInsensitiveContains(searchBar.text!) {
                tempSearch.append(rocket)
            }
        }
        
//        Search text empty after searching done
        rockets = tempSearch
        tableView.reloadData()
        searchBar.text = ""
    }
}


//Performing Animation task

extension ViewController {
    
    func AnimationDone() {
        
//        Instance of AnimationView
        let animationView = AnimationView()
        
//        Set animation, frame, mode, etc
        animationView.animation = Animation.named("rocket")
        animationView.frame = view.frame
        animationView.contentMode = .center
        animationView.loopMode = .playOnce
    
//        add in subview and start animation
        view.addSubview(animationView)
        animationView.play { (finished) in
            
//            After complete animation show searchBar, headtext and call function to show other details
            animationView.isHidden = true
            self.searchBar.isHidden = false
            self.name.text = "SpaceX"
            self.completion()
        }
    }
}

extension ViewController {
    
//    Showing the loading indicator
    func showLoadingIndicator() {
        aView = UIView(frame: self.view.bounds)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView.center
        ai.startAnimating()
        aView.addSubview(ai)
        self.view.addSubview(aView)
    }
    
//    Stop the loading indicator
    func stopLoadingIndicator() {
        aView.removeFromSuperview()
    }
}
