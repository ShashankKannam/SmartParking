//
//  MainViewController.swift
//  IoTProject
//  Created by Project NMWSU on 12/12/16.
//  Copyright © 2016 Project NMWSU. All rights reserved.
//

import UIKit

typealias completed = () -> ()

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var buttonCount = 0


    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func secretRefresh(_ sender: UIButton) {
        
        
        print("clicked secret button")
        
        buttonCount += 1
        
        if buttonCount == 1{
            
            if spots.count>0{
                
                
                spots = [Spot]()
                openSpots = [Spot]()
                closedSpots = [Spot]()
                
                downloadSpots {
                    self.tableView.reloadData()
                }
            }
            else{
                downloadSpots {
                    self.tableView.reloadData()
                    //ActivitySpinner.hide()
                }
            }
        }else{
            buttonCount = 0
        }
    }

  
    @IBAction func refreshButton(_ sender: Any) {
      
        buttonCount += 1
        
        if buttonCount == 1{
        
        if spots.count>0{
            

            spots = [Spot]()
            openSpots = [Spot]()
            closedSpots = [Spot]()
            
            downloadSpots {
                self.tableView.reloadData()
            }
        }
        else{
            downloadSpots {
                self.tableView.reloadData()
                //ActivitySpinner.hide()
            }
        }
        }else{
            buttonCount = 0
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
   
    
    override func viewDidAppear(_ animated: Bool) {
        ActivitySpinner.show("Please Wait...", disableUI: true)
        if spots.count > 0{
            self.downloadSpots {
            }
             ActivitySpinner.hide()
        }
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.tableView.reloadData()
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
      
       // ActivitySpinner.show("", disableUI: true)
        
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
                            else{
                                self.spotStatus[0] = "Closed"
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
                    print("done downloading intial data")
                    ActivitySpinner.hide()
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
            else{
                print("error here is : \(statusCode)")
                ActivitySpinner.hide()
                let alert = UIAlertController(title: "Sorry, Can't connect to internet", message: "Please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
        self.tableView.reloadData()
        ActivitySpinner.hide()
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
