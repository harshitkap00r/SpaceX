//
//  DetailsViewController.swift
//  SpaceX
//
//  Created by Get My Parking on 03/02/22.
//

import UIKit
import Lottie

class DetailsViewController: UIViewController {
    
    
//    Name and image of that Rocket
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
//    Link of details of rocket
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var wikipediaButton: UIButton!
    @IBOutlet weak var redditButton: UIButton!
    
//    Details of rocket
    @IBOutlet weak var gridfins: UILabel!
    @IBOutlet weak var legs: UILabel!
    @IBOutlet weak var reused: UILabel!
    @IBOutlet weak var landing_attempt: UILabel!
    @IBOutlet weak var landing_type: UILabel!
    @IBOutlet weak var landing_success: UILabel!
    @IBOutlet weak var presskit: UILabel!
    @IBOutlet weak var youtube_id: UILabel!
    
    //    Store the id of selected row of rocket
    static var rocketId: String = ""
    var details: SpecificRocketData?
    var aView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Set title of each button and hide them
        youtubeButton.setTitle("youtubeButton", for: .normal)
        youtubeButton.titleLabel?.isHidden = true
        wikipediaButton.setTitle("wikipediaButton", for: .normal)
        wikipediaButton.titleLabel?.isHidden = true
        redditButton.setTitle("redditButton", for: .normal)
        redditButton.titleLabel?.isHidden = true
        
//        Call to load data
        loadItem()
    }
    
    
    func loadItem() {

//        Show loading until fetch details of specific rocket
        showLoadingIndicator()
        ProcessingRequest().fetchLaunch(senderObject: self, id: DetailsViewController.rocketId) {
            
//            Call for image set from web
            self.setImage(url: self.details?.links?.patch?.small) {
                DispatchQueue.main.async {
                    
//                    Stop the loading and set title, button image
                    self.stopLoadingIndicator()
                    self.titleName.text = self.details?.name
                    self.youtubeButton.setImage(UIImage(named: "youtube"), for: .normal)
                    self.wikipediaButton.setImage(UIImage(named: "wikipedia"), for: .normal)
                    self.redditButton.setImage(UIImage(named: "reddit"), for: .normal)
                    
//                    Set the extra details of that rocket
                    self.showCoreDetails()
                }
            }
        }
    }
    
//    Set the details of thet rocket like leg, resued, grid, etc
    func showCoreDetails() {
        
        if let grid = self.details?.cores[0].gridfins {
            self.gridfins.text = "Gridfins: " + (grid ? "Yes" : "No")
        } else {
            self.gridfins.text = "Gridfins: " + "Not Found"
        }
        
        if let leg = self.details?.cores[0].legs {
            self.legs.text = "Legs: " + (leg ? "Yes" : "No")
        } else {
            self.legs.text = "Legs: " + "Not Found"
        }
        
        if let reused = self.details?.cores[0].reused {
            self.reused.text = "Resued: " + (reused ? "Yes" : "No")
        } else {
            self.reused.text = "Resued: " + "Not Found"
        }
        
        if let landingAttempt = self.details?.cores[0].landing_attempt {
            self.landing_attempt.text = "Landing Attempt: " + (landingAttempt ? "Yes" : "No")
        } else {
            self.landing_attempt.text = "Landing Attempt: " + "Not Found"
        }
        
        if let landingType = self.details?.cores[0].landing_type {
            self.landing_type.text = "Landing Type: " + landingType
        } else {
            self.landing_type.text = "Landing Type: " + "Not Found"
        }
        
        if let landingSuccess = self.details?.cores[0].landing_success {
            self.landing_success.text = "Landing Success: " + (landingSuccess ? "Yes" : "No")
        } else {
            self.landing_success.text = "Resued: " + "Not Found"
        }
        
        if let presskit = self.details?.links?.presskit {
            self.presskit.text = "Presskit: " + presskit
        } else {
            self.presskit.text = "Presskit: " + "Not Found"
        }
        
        if let youtube_id = self.details?.links?.youtube_id {
            self.youtube_id.text = "Youtube Id: " + youtube_id
        } else {
            self.youtube_id.text = "Youtube Id: " + "Not Found"
        }
    }
    
    
    
    func setImage(url: String?, completion: @escaping ()->()) {
        
//        Request the url of image and shows on screen
        if url != nil {
            if let imageURL = URL(string: url!) {
                DispatchQueue.main.async {
                    
//                    Decode the image data
                    if let imageData = try? Data(contentsOf: imageURL) {
                        let image = UIImage(data: imageData)
                        
//                        Set image in title image
                        self.titleImage.image = image
                        completion()
                    }
                }
            }
        }
    }
    
    
//    When click on  youtube, wikipedia, reddit button
    @IBAction func clickOnLink(_ sender: UIButton) {
        
        var url: URL?
        print(sender.currentTitle!)
        if sender.currentTitle == "youtubeButton" {
            url = URL(string: details?.links?.webcast ?? "")
        } else if sender.currentTitle == "wikipediaButton" {
            url = URL(string: details?.links?.wikipedia ?? "")
        } else if sender.currentTitle == "redditButton" {
            url = URL(string: details?.links?.reddit?.launch ?? "")
        }
        
//        If url not found show a alert else
        guard url != nil else {
            alert()
            return
        }
        
//        Open browser using that link
        UIApplication.shared.open(url!)
    }
    
//    Alert when link not found
    func alert() {
        let alert = UIAlertController(title: "Sorry", message: "Link not found.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension DetailsViewController {
    
    func showLoadingIndicator() {
        aView = UIView(frame: self.view.bounds)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView.center
        ai.startAnimating()
        aView.addSubview(ai)
        self.view.addSubview(aView)
    }
    func stopLoadingIndicator() {
        aView.removeFromSuperview()
    }
}
