//
//  Data.swift
//  SpaceX
//
//  Created by Get My Parking on 02/02/22.
//

import Foundation

struct ProcessingRequest{
    
//    Fetch data of all rocket launches
    func fetchLaunches(senderObject: ViewController, completion: @escaping ()->()) {
        
        if let url = URL(string: "https://api.spacexdata.com/v4/launches/") {
            let session = URLSession(configuration: .default)
            
//            Convert json data and store in instance of ViewController
            let task = session.dataTask(with: url) { (data, response, error) in 
                if error != nil {
                    print(error!)
                } else {
                    do {
                        let decodedData = try JSONDecoder().decode([AllRocketData].self, from: data!)
                        senderObject.rockets = decodedData
                        
//                        After assign data move to the ViewController
                        completion()
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    
//    Fetch data of specific rocket launch
    func fetchLaunch(senderObject: DetailsViewController, id: String, completion: @escaping ()->()) {
        
        if let url = URL(string: "https://api.spacexdata.com/v4/launches/" + id) {
            let session = URLSession(configuration: .default)
            
//            Convert json data and store in instance of DetailsViewController
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                } else {
                    do {
                        let decodedData = try JSONDecoder().decode(SpecificRocketData.self, from: data!)
                        senderObject.details = decodedData
//                        After assign data move to the DetailsViewController
                        completion()
                    } catch {
                    }
                }
            }
            task.resume()
        }
    }
}
