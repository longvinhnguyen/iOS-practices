//
//  TransitionController.swift
//  Logo Reveal
//
//  Created by Long Vinh Nguyen on 12/18/14.
//  Copyright (c) 2014 Underplot ltd. All rights reserved.
//

import UIKit
import QuartzCore

class TransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationDuration = 1.0
    
    var animating = false
    
    var operation : UINavigationControllerOperation = .Push
    
    weak var storedContext : UIViewControllerContextTransitioning? = nil
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return animationDuration
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        
        if operation == .Push {
            
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as MasterViewController
            
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as DetailViewController
            
            
            transitionContext.containerView().addSubview(toVC.view)
            
            // grow logo
            let animation = CABasicAnimation(keyPath: "transform")
            animation.toValue = NSValue(CATransform3D:
             CATransform3DConcat(CATransform3DMakeTranslation(0, -10, 0), CATransform3DMakeScale(75, 75, 1.0)))
            animation.duration = animationDuration
            animation.delegate = self
            
            fromVC.logo.addAnimation(animation, forKey: nil)
            
            toVC.maskLayer.opacity = 0
            
            let fadeIn = CABasicAnimation(keyPath: "opacity")
            fadeIn.duration = animationDuration
            fadeIn.toValue = 1.0
            toVC.maskLayer.addAnimation(fadeIn, forKey: nil)
            toVC.maskLayer.addAnimation(animation, forKey: nil)
            
        } else {
            // pop
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as DetailViewController
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as MasterViewController
            
            transitionContext.containerView().insertSubview(toVC.view, belowSubview: fromVC.view)
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                fromVC.view.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled())
            storedContext = nil
            animating = false
        }
    }
    
}
