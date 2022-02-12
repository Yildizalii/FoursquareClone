//
//  AddPlacesVC.swift
//  FoursquareClone
//
//  Created by Ali on 9.02.2022.
//

import UIKit
import MapKit
class AddPlacesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmosText: UITextField!
    @IBOutlet weak var selectImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewClicked))
        selectImage.addGestureRecognizer(gestureRecognizer)
    }
    @objc func imageViewClicked() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextButton(_ sender: Any) {
        if placeNameText.text != "" && placeTypeText.text != "" && placeAtmosText.text != "" {
            if let chosenImage = selectImage.image {
                PlaceModel.sharedInstance.placeName = placeNameText.text!
                PlaceModel.sharedInstance.placeType = placeTypeText.text!
                PlaceModel.sharedInstance.placeAtmosphere = placeAtmosText.text!
                PlaceModel.sharedInstance.placeImage = chosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }else {
            let alert = UIAlertController(title: "Error", message: "PlaceName/Type/Atmosphere??", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
