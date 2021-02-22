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

import UIKit
import MoPub

class MoPubBannerViewController: BaseViewController {

    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerAdUnitIDTextField: UITextField!
    
    var moPubBanner : MPAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "MoPubBannerAdUnitID") != nil && UserDefaults.standard.object(forKey: "MoPubBannerAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "MoPubBannerAdUnitID") as? String : MOPUB_BANNER_AD_UNIT_ID
        bannerAdUnitIDTextField.inputAccessoryView = toolBar
        moPubBanner = MPAdView(adUnitId: bannerAdUnitIDTextField.text)
        moPubBanner.frame = CGRect(x: 0, y: 0, width: self.bannerAdContainer.frame.size.width, height: self.bannerAdContainer.frame.size.height)
        moPubBanner.delegate = self
        moPubBanner.stopAutomaticallyRefreshingContents()
        bannerAdContainer.addSubview(moPubBanner)
    }

    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if bannerAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(bannerAdUnitIDTextField.text, forKey: "MoPubBannerAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        moPubBanner.adUnitId = bannerAdUnitIDTextField.text
        moPubBanner.loadAd()
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
}

extension MoPubBannerViewController : MPAdViewDelegate
{
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "MoPub Banner did load")
    }
    
    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "MoPub Banner did fail to load with error: \(String(describing: error))")
    }
    
    func willLeaveApplication(fromAd view: MPAdView!) {
        showAlertAction(withMessage: "View Controller will leave application")
    }
}

extension MoPubBannerViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        bannerAdUnitIDTextField.text = content
    }
}
