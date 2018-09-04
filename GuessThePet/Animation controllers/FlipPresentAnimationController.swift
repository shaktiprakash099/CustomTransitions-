///// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class FlipPresentAnimationController: NSObject,UIViewControllerAnimatedTransitioning {
  private let originalFrame: CGRect
  init(originalFrame:CGRect){
    self.originalFrame = originalFrame
  }
  
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromVc = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to),let snapshots = toVC.view.snapshotView(afterScreenUpdates: true) else{
        return
    }
    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
    snapshots.frame = originalFrame
    snapshots.layer.cornerRadius = CardViewController.cardCornerRadius
    snapshots.layer.masksToBounds = true
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshots)
    toVC.view.isHidden = true
     AnimationHelper.perspectiveTransform(for: containerView)
    snapshots.layer.transform = AnimationHelper.yRotation(.pi / 2)
    
    let duration = transitionDuration(using: transitionContext)
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic,
                            animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
        fromVc.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
      }
      UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3){
          snapshots.layer.transform = AnimationHelper.yRotation(0.0)
      }
      UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                                snapshots.frame = finalFrame
                                snapshots.layer.cornerRadius = 0
        }
      
      
    },
            completion: { _ in
                              toVC.view.isHidden = false
                              snapshots.removeFromSuperview()
                              fromVc.view.layer.transform = CATransform3DIdentity
                              transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
    
  
  
  }

}
