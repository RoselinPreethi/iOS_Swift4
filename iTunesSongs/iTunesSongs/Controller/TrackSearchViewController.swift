//
//  TrackSearchViewController.swift
//  iTunesSongs
//
//  Created by Malini on 02/04/18.
//  Copyright © 2018 Roselin. All rights reserved.
//

import UIKit

class TrackSearchViewController: UIViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var songstable: UITableView!
    
    var networkService:NetworkService?
    
    var tracks:[Track]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       networkService = NetworkService()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    
    func getTracks(searchedKeyword:String){
        networkService?.get(baseUrl: EndPoints.baseURL.rawValue, path: paths.search.rawValue, parameters: "media=music&entity=song&term=\(searchedKeyword)", completion: { (tracks, error) in
                
                if let _error = error {
                    
                    let alertController = UIAlertController(title:"Message", message: _error, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)

                }
                self.tracks = tracks
                self.songstable.reloadData()
        })
    }
   
}

    extension TrackSearchViewController: UITableViewDataSource {
        
      public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _tracks = self.tracks{
          return _tracks.count
        }
        return 0
    }
        
       public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
       
            let cell = songstable.dequeueReusableCell(withIdentifier: "trackcell", for:indexPath) as! TrackTableCell
        
      if let _track = self.tracks {
        let track = _track[indexPath.row]
            cell.song1lbl.text = track.artistName
            cell.song2lbl.text = track.trackName
        }
      else{
        cell.song1lbl.text = ""
        cell.song2lbl.text = ""
           
        
        }
        return cell
    }
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1;
        }
}
    
    extension TrackSearchViewController: UISearchBarDelegate{
        public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
            
            if let text = searchbar.text, text.count > 0 {
                self.getTracks(searchedKeyword: text)
                searchBar.resignFirstResponder()
            
        }
    }
    
    
}


