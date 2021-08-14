//
//  WelcomeViewController.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/14/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var holderView: UIView!
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureScreen()
        
    }
    
    private func configureScreen() {
        //set up the scroll view
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        let titles: [String] = ["Welcome", "Location", "Start Browsing"]
        
        for indexNumber in 0..<3 {
            let pageView = UIView(frame: CGRect(
                                    x     : CGFloat(indexNumber) * holderView.frame.width,
                                    y     : 0,
                                    width : holderView.frame.width,
                                    height: holderView.frame.height))
            scrollView.addSubview(pageView)
            
            //Title, Image, button, PROGRAMATTICALLY
            let label = UILabel(
                frame: CGRect(
                    x     : 0,
                    y     : 0,
                    width : pageView.frame.width-20,
                    height: 120))
            
            let imageView = UIImageView(
                frame: CGRect(
                    x     : 60,
                    y     : 190,
                    width : pageView.frame.width - 120,
                    height: pageView.frame.height - 420)
            )
            
            let button = UIButton(
                frame: CGRect(
                    x     : 10,
                    y     : pageView.frame.height-60,
                    width : pageView.frame.width-20,
                    height: 50)
            )
            
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            pageView.addSubview(label)
            label.text = titles[indexNumber]
            
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "image_\(indexNumber+1)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            
            switch indexNumber {
                case 0:
                    button.setTitle("Welcome Aboard", for: .normal)
                case 1:
                    button.setTitle("Next", for: .normal)
                default:
                    button.setTitle("Start Browsing", for: .normal)
            }
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = indexNumber+1
            pageView.addSubview(button) //to have the appearance of the button
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.width*3, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 3 else {
            //User defaults goes here
            Core.shared.isNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        // scroll to the next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.width * CGFloat(button.tag), y: 0), animated: true)
    }

}
