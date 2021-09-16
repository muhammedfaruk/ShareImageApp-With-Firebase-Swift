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
    
    /*
    var emailArray = [String]()
    var imageArray  = [String]()
    var commentArray = [String]()
    */
    
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFirebaseDocumentData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func getFirebaseDocumentData(){
        
        let firestoreDataBase = Firestore.firestore()
        
        firestoreDataBase.collection("Post").order(by: "Tarih", descending: true).addSnapshotListener {snapshot, error in
            //denemee
            if error != nil {// verileri çekmede hata yaşandı
                print(error?.localizedDescription ?? "Error")
            }else {
                print("veri alnıyor")
                if snapshot?.isEmpty == false && snapshot != nil{
                    
                    self.postArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        if let ImageUrlData = document.get("gorselURL") as? String{
                            
                            if let mailData = document.get("gmail") as? String{
                                
                                if let commentData = document.get("yorum") as? String{
                                    
                                    let post = Post(email: mailData, image: ImageUrlData, comment: commentData)
                                    self.postArray.append(post)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()                                       
                }
                             
            }
        }
            
            
            
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedViewCell   // burada Cell id sini verdiğimiz hücreye ulaştık ve oradaki değişkenleri kullanabiliriz artık
        
        cell.emailText.text = postArray[indexPath.row].email
        cell.commentTextField.text = postArray[indexPath.row].comment
        
        cell.postImageView.sd_setImage(with: URL(string: postArray[indexPath.row].image), placeholderImage: UIImage(named: "placeholder"))
                        
        return cell
    }
   

}
