//
//  ViewController.swift
//  FacebookLikeAnimation
//
//  Created by Abhinay on 11/07/18.
//  Copyright © 2018 ONS. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let bgImageView:UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "FB_BG"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likeImageView:UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "like"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "FB Like Demo"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Optima", size: 37.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emojiContainerView:UIView = {
        
        let padding:CGFloat = 6.0
        let height:CGFloat = 38.0
        
        let images = [#imageLiteral(resourceName: "laugh"), #imageLiteral(resourceName: "joy"), #imageLiteral(resourceName: "sad"), #imageLiteral(resourceName: "love"), #imageLiteral(resourceName: "wink")]
        let totalImages = CGFloat(images.count)
        
        let view = UIView()
        let width = (totalImages * height) + ((totalImages + 1) * padding)
        
        view.backgroundColor = .white
        
        
        let arrangedSubviews = images.map({ (image) -> UIImageView in
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = height/2.0
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isBaselineRelativeArrangement = true
        view.addSubview(stackView)
        
        view.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height + (2 * padding))
        view.layer.cornerRadius = view.frame.height/2.0
        
        //Add Shadow
        view.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        
        stackView.frame = view.frame
        
        return view
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Utility.getColorFromRGB(red: 72, green: 104, blue: 173)
        //view.addSubview(bgImageView)
        view.addSubview(likeImageView)
        view.addSubview(titleLabel)
        setAutoLayout()
        setLongPressGuesture()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    fileprivate func setAutoLayout()
    {
        
//        bgImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        bgImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        bgImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        bgImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        let viewsDict = ["titleLabel":titleLabel]
        let constriantH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLabel]-15-|", options: [], metrics: nil, views: viewsDict)
        let constriantV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-74-[titleLabel]", options: [], metrics: nil, views: viewsDict)
        
        
        likeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        likeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        likeImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        likeImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        view.addConstraints(constriantH)
        view.addConstraints(constriantV)
        
        
    }
    
    fileprivate func setLongPressGuesture()
    {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapPressed))
        view.addGestureRecognizer(longTapGesture)
        
    }
    
    @objc fileprivate func longTapPressed(gesture:UILongPressGestureRecognizer)
    {
        
        if gesture.state == .began{
           handleGestureBegan(gesture: gesture)
        }else if gesture.state == .ended{
           handleGestureEnd(gesture: gesture)
        }else if gesture.state == .changed{
           handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureBegan(gesture:UILongPressGestureRecognizer)
    {
        view.addSubview(emojiContainerView)
        let pressedLocation = gesture.location(in: view)
        
        emojiContainerView.center.x = view.center.x
        self.emojiContainerView.alpha = 0.0
        
        emojiContainerView.transform = CGAffineTransform(translationX: 0.0, y: pressedLocation.y)
        
        
        UIView.animate(withDuration: 0.30, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.emojiContainerView.alpha = 1.0
            self.emojiContainerView.transform = CGAffineTransform(translationX: 0.0, y: pressedLocation.y - self.emojiContainerView.frame.size.height)
        })
    }
    
    fileprivate func handleGestureChanged(gesture:UILongPressGestureRecognizer)
    {
        let location = gesture.location(in: emojiContainerView)
        let stackView = emojiContainerView.subviews.first
        let fixedYLoc = CGPoint(x: location.x, y: emojiContainerView.frame.size.height / 2.0)
        
        guard let imageViews = stackView?.subviews else {
            return
        }
        
        let hitTestView = emojiContainerView.hitTest(fixedYLoc, with: nil)
        
        if hitTestView is UIImageView{
            
            UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseIn, animations: {
                
                for imageView in imageViews
                {
                    UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseIn, animations: {
                        imageView.transform = CGAffineTransform.identity
                    })
                }
                hitTestView!.transform = CGAffineTransform(translationX: 0.0, y: -50)
            })
        }
        
    }
    
    fileprivate func handleGestureEnd(gesture:UILongPressGestureRecognizer)
    {
        let stackView = emojiContainerView.subviews.first
        
        guard let imageViews = stackView?.subviews else {
            return
        }
        
        
        UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseIn, animations:
            {
            
            for imageView in imageViews
            {
                UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseIn, animations: {
                    imageView.transform = CGAffineTransform.identity
                })
            }
                self.emojiContainerView.alpha = 0
                self.emojiContainerView.transform = CGAffineTransform(translationX: 0.0, y: self.emojiContainerView.frame.origin.y + self.emojiContainerView.frame.size.height)
        }, completion: { (status) in
            self.emojiContainerView.removeFromSuperview()
        })
        
       
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

class Utility
{
    static func getColorFromRGB(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor
    {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}

