//
//  FeedViewController.swift
//  ShareImageApp
//
//  Created by Muhammed Faruk Söğüt on 14.09.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var imageArray  = [String]()
    var commentArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFirebaseDocumentData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func getFirebaseDocumentData(){
        
        let firestoreDataBase = Firestore.firestore()
        
        firestoreDataBase.collection("Post").addSnapshotListener {snapshot, error in
            
            if error != nil {// verileri çekmede hata yaşandı
                print(error?.localizedDescription)
            }else {
                print("veri alnıyor")
                if snapshot?.isEmpty == false && snapshot != nil{
                    
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        if let ImageUrlData = document.get("gorselURL") as? String{
                            
                            self.imageArray.append(ImageUrlData)
                            
                        }
                       
                        if let mailData = document.get("gmail") as? String{
                            self.emailArray.append(mailData)
                        }
                        if let commentData = document.get("yorum") as? String{
                            
                            self.commentArray.append(commentData)
                        }
                    }
                    
                    self.tableView.reloadData()                                       
                }
                             
            }
        }
            
            
            
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedViewCell   // burada Cell id sini verdiğimiz hücreye ulaştık ve oradaki değişkenleri kullanabiliriz artık
        
        cell.emailText.text = emailArray[indexPath.row]
        
        cell.commentTextField.text = commentArray[indexPath.row]
        
        cell.postImageView.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage(named: "placeholder"))
        
        
        
        return cell
    }
   

}
