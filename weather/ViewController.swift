//
//  ViewController.swift
//  weather
//
//  Created by Yermakov Anton on 03.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var imagelbl: UIImageView!
    @IBOutlet weak var tempMaxLbl: UILabel!
    @IBOutlet weak var tempMinLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    var degree : Int!
    var condition : String!
    var icon : String!
    var city : String!
    var date: String!
    var maxTemp : Int!
    var minTemp : Int!
    
    
    
    var exists : Bool = true
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let urlRequest = URLRequest(url: URL(string: "https://api.apixu.com/v1/forecast.json?key=2c6a1296c0074447ab7132848173004&q=\(search.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let current = json["current"] as? [String : AnyObject]{
                        if let temp = current["temp_c"] as? Int{
                            self.degree = temp
                        }
                        
                        if let condition = current["condition"] as? [String : AnyObject]{
                            self.condition = condition["text"] as! String
                            let iconeee = condition["icon"] as! String
                            self.icon = "https:\(iconeee)"
                        }
                        
                    

                    }
                    
                    if let location = json["location"] as? [String : AnyObject]{
                        if let name = location["name"] as? String{
                            self.city = name
                        }
                    }
                    
                    if let _ = json["error"]{
                        self.exists = false
                    }
                    
                    if let forecast = json["forecast"] as? [String : AnyObject]{
                        if let forecastday = forecast["forecastday"] as? [[String : AnyObject]]{
                            
                            
                        if let date = forecastday.first?["date"] as? String{
                                        self.date = date
                                }
                            
                        if let day = forecastday.first?["day"] as? [String : AnyObject]{
                                if let maxtemp = day["maxtemp_c"] as? Int{
                                        self.maxTemp = maxtemp
                                }
                        if let mintemp = day["mintemp_c"] as? Int{
                                        self.minTemp = mintemp
                                }
                            }
                        }
                    }
                            
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        if self.exists{
                            self.cityLbl.isHidden = false
                            self.degreeLbl.isHidden = false
                            self.conditionLbl.isHidden = false
                            self.imagelbl.isHidden = false
                            self.dateLbl.isHidden = false
                            self.tempMaxLbl.isHidden = false
                            self.tempMinLbl.isHidden = false
                            
                            self.cityLbl.text = self.city
                            self.degreeLbl.text = self.degree.description
                            self.conditionLbl.text = self.condition
                            self.imagelbl.downloadImage(from: self.icon)
                            self.dateLbl.text = self.date
                            self.tempMaxLbl.text = "Max. temperature: \(self.maxTemp.description)"
                            self.tempMinLbl.text = "Min. temperature: \(self.minTemp.description)"
                        } else {
                            self.cityLbl.text = "Not much city found!"
                            self.degreeLbl.isHidden = true
                            self.conditionLbl.isHidden = true
                            self.imagelbl.isHidden = true
                            self.dateLbl.isHidden = true
                            self.tempMinLbl.isHidden = true
                            self.tempMaxLbl.isHidden = true
                        }
                    }
                    
                    
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       search.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIImageView{
    
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
}









