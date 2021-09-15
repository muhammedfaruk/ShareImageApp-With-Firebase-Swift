//
//  UploadViewController.swift
//  ShareImageApp
//
//  Created by Muhammed Faruk Söğüt on 14.09.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func addImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                   
        imageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadClicked(_ sender: Any) {
        
        let storage = Storage.storage() // storega ulaştık
        let storeageReference = storage.reference() // nerede olduğumuzu belirttik
        
        let mediaFolder = storeageReference.child("media") // media adında klasör açtık
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){ // resimi dataya çevirdik
            
            let uuId = UUID().uuidString // unique bir id oluşturduk.. her resim için farklı olacak
            
            let imageReference = mediaFolder.child("\(uuId).jpg") // resimleri media folderın childı yaptık
            
            imageReference.putData(data, metadata: nil) { storageData, error in
                if error != nil {
                    self.alertMessage(Title: "Warning!", message: error?.localizedDescription ?? "Hata")
                }else {
                    imageReference.downloadURL { url, error in
                        
                        if error == nil{
                            let imageURL = url?.absoluteString // imagin linkini aldık
                                                        
                            // VERİLERİ DATAYA YAZIYORUZ
                            if let imageUrl = imageURL{
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                let fireStorePost = ["gorselURL" : imageUrl, "gmail" : Auth.auth().currentUser?.email, "yorum" : self.uploadTextField!.text, "Tarih" : FieldValue.serverTimestamp()] as [String : Any]
                               
                                
                                firestoreDatabase.collection("Post").addDocument(data: fireStorePost) { error in
                                    
                                    if error != nil { // veri kayıt edilemedi
                                        self.alertMessage(Title: "Error", message: error?.localizedDescription ?? "Upload Error! Please check your internet connection")
                                    }
                                    else { //veri kayıt edildi
                                                                                
                                        self.imageView.image = UIImage(named: "selectImage")
                                        self.uploadTextField.text = ""
                                        
                                        self.tabBarController?.selectedIndex = 0 // tabbarController içindeki ilk sayfaya git
                                    }
                                }
                              
                            }
                            
                        }else { // url indirilirken hataa verildi
                            print(error?.localizedDescription ?? "error")
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    func dataSaved(alert : UIAlertAction){
        
     
        
        
    }
        
    
    func alertMessage(Title : String, message : String){
        let uıAlert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
        let uıButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
     
        self.present(uıAlert, animated: true, completion: nil)
    }
    

}
