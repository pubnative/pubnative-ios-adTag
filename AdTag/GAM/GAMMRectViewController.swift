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

class GAMMRectViewController : BaseViewController {

    @IBOutlet weak var mRectAdContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mRectAdUnitIDTextField: UITextField!

    var mRectView: GAMBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mRectAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "GAMMRectAdUnitID") != nil && UserDefaults.standard.object(forKey: "GAMMRectAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "GAMMRectAdUnitID") as? String : GAM_MRECT_AD_UNIT_ID
        mRectAdUnitIDTextField.inputAccessoryView = toolBar
        mRectView = GAMBannerView(adSize: kGADAdSizeMediumRectangle)
        mRectView.adUnitID = mRectAdUnitIDTextField.text
        mRectView.delegate = self
        mRectView.rootViewController = self
        mRectAdContainer.addSubview(mRectView)
    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if mRectAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(mRectAdUnitIDTextField.text, forKey: "GAMMRectAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        mRectView.adUnitID = mRectAdUnitIDTextField.text
        mRectView.load(GAMRequest())
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }

}

extension GAMMRectViewController : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "GAM MRect did load")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "GAM MRect did fail to load with error: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
    }
}

extension GAMMRectViewController : ScannerViewControllerDelegate {
    func scannerDetectedQRCode(withContent content: String) {
        mRectAdUnitIDTextField.text = content
    }
}
