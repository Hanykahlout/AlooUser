//
//  WebViewViewController.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 30/11/2021.
//

import UIKit
import WebKit
class WebViewViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var alooWebView: WKWebView!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var forwordBarButton: UIBarButtonItem!
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
            backBarButton.image = UIImage(systemName: "forward.frame")
            forwordBarButton.image = UIImage(systemName: "backward.frame")
        }else{
            backBarButton.image = UIImage(systemName: "backward.frame")
            forwordBarButton.image = UIImage(systemName: "forward.frame")
        }
        
        if let url = URL(string: link){
            alooWebView.load(URLRequest(url: url))
            alooWebView.allowsBackForwardNavigationGestures = true
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc @IBAction func backBarAction(_ sender: Any) {
        if alooWebView.canGoBack{
            alooWebView.goBack()
        }
        
    }
    
    
    @IBAction func forwordBarAction(_ sender: Any) {
        if alooWebView.canGoForward{
            alooWebView.goForward()
        }
    }
    
    
}
