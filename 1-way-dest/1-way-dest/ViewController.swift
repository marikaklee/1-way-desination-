//
//  ViewController.swift
//  1-way-dest
//
//  Created by Lee, Marika on 8/1/16.
//  Copyright © 2016 Lee, Marika. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON



class ViewController: UIViewController {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var summary: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    func originToDestination(originAddr: String, destAddr: String) {
        let service = "https://maps.googleapis.com/maps/api/directions/json"
        
        let urlString = ("\(service)?origin=\(originAddr)&destination=\(destAddr)&mode=driving&units=metric&sensor=true&key=AIzaSyC-LflNZIou4Lzdk8Wg_RM-MfvaWpqVdng").stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        let directionsURL = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: directionsURL!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let operation = AFHTTPRequestOperation(request: request)
        operation.responseSerializer = AFJSONResponseSerializer()
        
        operation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            if let result = responseObject as? NSDictionary {
                if let routes = result["routes"] as? [NSDictionary] {
                    
                    let routesJson = JSON(routes)
                    let summary = routesJson[0]["summary"].stringValue;
                    let distance = routesJson[0]["legs"][0]["duration"]["text"].stringValue;
                    
                    
                    self.time.text = distance;
                    self.summary.text = summary;
                    
                }
            }
            
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!)  -> Void in
            print("\(error)")
        }
        operation.start()
    }
    
    @IBAction func workToHome(sender: UIButton) {
        self.originToDestination("800 Concar Drive, San Mateo CA 94402", destAddr: "801 Church Street, Mountain View 994041");
    }
    

    
    @IBAction func homeToWork(sender: UIButton) {
        self.originToDestination("801 Church Street, Mountain View 994041", destAddr: "800 Concar Drive, San Mateo CA 94402");
    }
    

 
            
            
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

