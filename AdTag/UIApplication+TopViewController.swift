//
//  Copyright © 2018 PubNative. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

extension UIApplication
{
    func topViewController() -> UIViewController {
        return topViewController((UIApplication.shared.keyWindow?.rootViewController)!)
    }
    
    private func topViewController(_ rootViewController: UIViewController) -> UIViewController {
        
        if rootViewController.presentedViewController == nil {
            return rootViewController
        }
        
        if (rootViewController.presentedViewController?.isMember(of: UINavigationController.self))! {
            let navigationController = rootViewController.presentedViewController as! UINavigationController
            let lastViewController = navigationController.viewControllers.last
            return topViewController(lastViewController!)
        }
        
        if (rootViewController.presentedViewController?.isMember(of: UITabBarController.self))! {
            let tabController = rootViewController.presentedViewController as! UITabBarController
            let lastViewController = tabController.selectedViewController
            return topViewController(lastViewController!)
        }
        
        let presentedViewController = rootViewController.presentedViewController
        return topViewController(presentedViewController!)

    }
}
