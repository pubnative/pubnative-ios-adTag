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
import GoogleMobileAds

class DFPBannerViewController : BaseViewController {

    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerAdUnitIDTextField: UITextField!
    
    var dfpBanner: DFPBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "DFPBannerAdUnitID") != nil && UserDefaults.standard.object(forKey: "DFPBannerAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "DFPBannerAdUnitID") as? String : DFP_BANNER_AD_UNIT_ID
        bannerAdUnitIDTextField.inputAccessoryView = toolBar
        dfpBanner = DFPBannerView(adSize: kGADAdSizeBanner)
        dfpBanner.adUnitID = bannerAdUnitIDTextField.text
        dfpBanner.delegate = self
        dfpBanner.rootViewController = self
        bannerAdContainer.addSubview(dfpBanner)
    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if bannerAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(bannerAdUnitIDTextField.text, forKey: "DFPBannerAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        dfpBanner.load(DFPRequest())
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
}

extension DFPBannerViewController : GADBannerViewDelegate
{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "DFP Banner did load")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "DFP Banner did fail to load with error: \(error.localizedDescription)")
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "DFP Banner will present screen")
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "DFP Banner will dismiss screen")
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "DFP Banner did dismiss screen")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "View Controller will leave application")
    }
}

extension DFPBannerViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        bannerAdUnitIDTextField.text = content
    }
}
