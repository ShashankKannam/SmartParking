//
//  MainViewController.swift
//  IoTProject
//
//  Created by Project NMWSU on 12/12/16.
//  Copyright © 2016 Project NMWSU. All rights reserved.
//

import UIKit

typealias completed = () -> ()

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBAction func refresh(_ sender: Any) {
       
        if spots.count>0{
            spots = nil
            openSpots = nil
            closedSpots = nil
            downloadSpots {
                self.tableView.reloadData()
            }
        }
        
    }
  
  
    @IBAction func refreshButton(_ sender: Any) {
        
        if spots.count>0{
            spots = nil
            openSpots = nil
            closedSpots = nil
            downloadSpots {
                self.tableView.reloadData()
            }
        }
        else{
            downloadSpots {
                self.tableView.reloadData()
            }
        }

    }
    
    
    
    
    private var spots:[Spot]!
    
    private var openSpots:[Spot]!
    
    private var closedSpots:[Spot]!
    
    private var filteredSpots:[Spot]!
    
    private var filteredOpenSpots:[Spot]!
    
    private var filteredClosedSpots:[Spot]!
    
      private var spotNames:[String] = ["Parking Slot 1","Parking Slot 2","Parking Slot 3","Parking Slot 4", "Parking Slot 5"]
    
     private var spotStatus:[String] = ["Closed","Closed","Closed","Closed","Closed"]
    
    var inSearchMode:Bool = false
    
    
    var selectedSpot:Spot!

    //var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "update", userInfo: nil, repeats: true)

    
// var timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: Selector("downloadSpots"), userInfo: nil, repeats: true)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   // var k = Timer.scheduledTimer(timeInterval: 50, target: self, selector: "downloadSpots", userInfo: nil, repeats: true)
        self.hideKeyboardWhenTappedAround()
        
        selectedSpot = Spot(spotNameI: "", spotStatusI: "")

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.returnKeyType = UIReturnKeyType.done
        downloadSpots { 
            tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
//        spots.removeAll()
//        openSpots.removeAll()
//        closedSpots.removeAll()
        self.tableView.reloadData()
       // downloadSpots()
    }
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            tableView.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            if segmentedControl.selectedSegmentIndex == 0{
                filteredOpenSpots = openSpots.filter({($0.spotName.range(of: lower) != nil)})
            }
            else if segmentedControl.selectedSegmentIndex == 1{
                filteredSpots = spots.filter({($0.spotName.range(of: lower) != nil)})
            }
            else{
                filteredClosedSpots = closedSpots.filter({($0.spotName.range(of: lower) != nil)})
            }
            tableView.reloadData()
//            print("filtered spots and normal count")
//            print(filteredSpots.count)
//            print(spots.count)
        }
    
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 0{
            if inSearchMode{
                return filteredOpenSpots.count
                
            }else{
                
                return openSpots.count
            }
        }else if segmentedControl.selectedSegmentIndex == 1{
            if inSearchMode{
                return filteredSpots.count
            }else{
                
                return spots.count
            }
        }else{
            if inSearchMode{
                return filteredClosedSpots.count
                
            }else{
                
                return closedSpots.count
            }
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as? SpotCell{
            
            if segmentedControl.selectedSegmentIndex == 0{
                if inSearchMode{
                    let spotF = filteredOpenSpots[indexPath.row]
                    cell.updateUI(spot: spotF)
                }else{
                    let spot = openSpots[indexPath.row]
                    cell.updateUI(spot: spot)
                }
                return cell
                
            } else if segmentedControl.selectedSegmentIndex == 1{
                if inSearchMode{
                    let spotA = filteredSpots[indexPath.row]
                    cell.updateUI(spot: spotA)
                }else{
                    let spot = spots[indexPath.row]
                    
                    cell.updateUI(spot: spot)
                }
                return cell
                
            }
            else{
                if inSearchMode{
                    let spotC = filteredClosedSpots[indexPath.row]
                    cell.updateUI(spot: spotC)
                }else{
                    
                    let spot = closedSpots[indexPath.row]
                    
                    cell.updateUI(spot: spot)
                }
                return cell
            }
        }
        else{
            return UITableViewCell()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             selectedSpot = Spot(spotNameI: spotNames[indexPath.row], spotStatusI: spotStatus[indexPath.row])
    }
   
   
    func downloadSpots(completed: completed){
  
       // DispatchQueue.global().async {
        //    <#code#>
       // }
        spots = [Spot]()
        openSpots = [Spot]()
        closedSpots = [Spot]()
        
        var request = URLRequest(url: URL(string: "https://api.spark.io/v1/devices/43003b000347353138383138/closed?access_token=20c6b264ed1fc8bbf419052fad2108fbfc3261cf")!)
        
        let session = URLSession.shared

        request.httpMethod = "GET"

        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    // print(" here ......josn ...\(json)")
                    if let spotY = json as? Dictionary<String, Any>{
                       // print(spotY)
                        if let spotStatusZ = spotY["result"] as? Int{
                             print(spotStatusZ)
                            if spotStatusZ == 0{
                            self.spotStatus[0] = "Available"
                        }
                            for i in 0..<5{
                                self.spots.append(Spot(spotNameI: self.spotNames[i], spotStatusI: self.spotStatus[i]))
                            }
                     // open spots
                    
                    // closed spots

                        }
                        //print(spotY["result"])

                        for a in self.spots{
                            print(a.spotName)
                           print(a.spotStatus)
                            if a.spotStatus == "Available"{
                                self.openSpots.append(Spot(spotNameI: a.spotName, spotStatusI: a.spotStatus))
                            }else{
                               self.closedSpots.append(Spot(spotNameI: a.spotName, spotStatusI: a.spotStatus))
                            }
                        }
                        
                    }
                    
                    print("spots count open, all & closed")
                    print(self.openSpots.count)
                    print(self.spots.count)
                    print(self.closedSpots.count)
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
            else{
                print("error here is : \(statusCode)")
            }
        }
        task.resume()
        self.tableView.reloadData()
        completed()
        
}
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
