//
//  PhotoView.swift
//  Weather
//
//  Created by Winnie Zhu on 11/26/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class PhotoView: UIViewController {
    var city = ""

    @IBOutlet weak var photoView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabView = parent as! TabView
        SwiftSpinner.show("Fetching Google Images...")
        photoView.frame = CGRect(x: 0, y: 0, width: 350, height: UIScreen.main.bounds.height)
        photoView.isScrollEnabled = true
        if (tabView.fromInitial) {
            if (tabView.pageNumber < 0) {
                city = tabView.weatherData!.city
            } else {
                city = tabView.pageData!["city"].string!
            }
        } else {
            city = tabView.resultData!["city"].string!
        }
//        let paramaters: Parameters = ["city": self.city]
        let url1 = "http://zhuxuan-homework8.us-east-2.elasticbeanstalk.com/getCityPic?city="
        let url = convertURL(link: url1 + city)
        
    AF.request(url).responseData{response in
        switch response.result {
            case let .success(data):
                let data = JSON(data)
                self.photoView.contentSize = CGSize(width: 350, height: 470*data["picData"]["items"].count)
                for i in 0..<data["picData"]["items"].count {
                    let url = data["picData"]["items"][i]["link"].url
                    self.getData(from: url!) { data, response, error in
                        guard let data = data, error == nil else { return }
                        print(response?.suggestedFilename ?? url!.lastPathComponent)
                        print("Download Finished")
                        DispatchQueue.main.async() {
                            let image = UIImage(data: data)
                            let imageView = UIImageView(image: image!)
//                            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
                            imageView.frame = CGRect(x: 25, y: i*470, width: 365, height: 470)
                             self.photoView.addSubview(imageView)
                        }
                    }
                }
        case .failure(_): break
            }
        
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            SwiftSpinner.hide()
        }
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func convertURL(link: String) -> URL {
        let urlStr : String = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let convertedURL : URL = URL(string: urlStr)!
        return convertedURL
    }

}
