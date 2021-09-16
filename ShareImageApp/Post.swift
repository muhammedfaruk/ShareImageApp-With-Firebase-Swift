//
//  Post.swift
//  ShareImageApp
//
//  Created by Muhammed Faruk Söğüt on 16.09.2021.
//

import Foundation

class Post {
    
    let email : String
    let image : String
    let comment : String
    
    
    init(email : String, image : String, comment: String) {
        self.email = email
        self.comment = comment
        self.image = image
    }
    
    
}
