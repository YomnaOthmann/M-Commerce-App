//
//  LaunchScreenViewController.swift
//  Shopify
//
//  Created by Mac on 01/03/2024.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var launchScreenImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.animation()
        })
    }
    private func animation(){
        UIView.animate(withDuration: 1.0, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.launchScreenImage.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)

        })
        
        UIView.animate(withDuration: 1.5, animations: {
            self.launchScreenImage.alpha = 0
        },completion: { done in
            if done {
                self.showAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                    self.performSegue(withIdentifier: "home", sender: self)

                })
            }
            
        })
    }
    
    func showAnimation(){
        let animationView : LottieAnimationView = LottieAnimationView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        animationView.center = self.view.center
        
        self.view.addSubview(animationView)
        guard let path = Bundle.main.path(forResource: "shopLink", ofType: "json")else{
            return
        }
        let url = URL(fileURLWithPath: path)
        LottieAnimation.loadedFrom(url: url) { animation in
            
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            
            animationView.loopMode = .playOnce
            
            animationView.animationSpeed = 1.0
            
            animationView.play()
           
        }
 
        DispatchQueue.main.asyncAfter(deadline: .now()+4){
            animationView.stop()
            animationView.removeFromSuperview()
        }
    }

}

