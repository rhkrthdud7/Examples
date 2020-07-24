//
//  FirstViewController.swift
//  TransitionExample
//
//  Created by Soso on 2020/07/21.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let transition = TransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(type(of: self), #function)
        view.backgroundColor = .blue
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(type(of: self), #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let second = SecondViewController()
            second.transitioningDelegate = self.transition
            second.modalPresentationStyle = .fullScreen
            self.present(second, animated: true, completion: nil)
        }
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        print(type(of: self), #function)
        view.backgroundColor = .red
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print(type(of: self), #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatorPresent()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatorDismiss()
    }
}

class AnimatorPresent: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else { return }

        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0

        UIView.animate(withDuration: 1, animations: {
            toView.alpha = 1
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class AnimatorDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else { return }

        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        fromView.alpha = 1

        UIView.animate(withDuration: 1, animations: {
            fromView.alpha = 0
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
