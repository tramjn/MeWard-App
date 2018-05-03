//
//  ItemDetail.swift
//  MeWard
//
//  Created by Tram Nguyen on 4/30/18.
//  Copyright © 2018 Tram Nguyen. All rights reserved.
//

// didn't end up using


import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ItemDetail: ItemDetailQuery {
    //    var itemListDetailVC: ItemListDetailVC?
    //    var searchQuery: String
    struct itemStruct {
        var itemTitle: String
        var itemImage: UIImage
    }
    
    
    var currentItemTitle: String!
    var currentItemImage: UIImage!
    
    
    // tried to use Google Custom API but had trouble with putting JSON request in my code
    func getItemSearch(completed: @escaping () -> ()) {

        let searchURL = googleUrlBase + googleAPIKey + customSearchKey + "q=" + searchQuery

        Alamofire.request(searchURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let title = json["items"]["pagemap"]["metatags"]["ogtitle"].string {
                    self.currentItemTitle = title
                } else {
                    print("Could not find item")
                }
                if let imageURL = json["items"]["pagemap"]["cse_image"]["src"].string {
                    Alamofire.request(imageURL).responseImage(completionHandler: {response in debugPrint(response)})
                    debugPrint(response.result)
                    if let imageResult = response.result.value {
                        let image = UIImage(data: imageResult as! Data)
                        self.currentItemImage = image
                    } else {
                        print("*** error in downloading image")
                    }

                } else {
                    print("could not find image url")
                }



            case .failure(let error):
                print(error)
            }
            completed()
        }
    }

}



