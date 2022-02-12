//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Ali on 9.02.2022.
//

import UIKit
import Parse
class PlacesVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonCliked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutButtonClicked))
        tableView.delegate = self
        tableView.dataSource = self
    getDataFromParse()
    }
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(messageInput: error?.localizedDescription ?? "Error!", titleInput: "Error!")
            }else {
                if objects != nil {
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                        if let placeName =  object.object(forKey: "name") as? String {
                            if let placeId = object.objectId    {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    @objc func addButtonCliked() {
        self.performSegue(withIdentifier: "toAddPlacesVC", sender: nil)
    }
    @objc func logOutButtonClicked() {
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(messageInput: error?.localizedDescription ?? "Error!", titleInput: "Error!" )
            }else {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }
    func makeAlert(messageInput : String , titleInput : String) {
        let alert = UIAlertController(title: titleInput, message:messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlaceId = selectedPlaceId
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}
