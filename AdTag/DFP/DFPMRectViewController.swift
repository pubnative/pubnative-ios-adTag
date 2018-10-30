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

class DFPMRectViewController : BaseViewController {

    @IBOutlet weak var mRectAdContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mRectAdUnitIDTextField: UITextField!

    var dfpMRect: DFPBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mRectAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "DFPMRectAdUnitID") != nil && UserDefaults.standard.object(forKey: "DFPMRectAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "DFPMRectAdUnitID") as? String : DFP_MRECT_AD_UNIT_ID
        mRectAdUnitIDTextField.inputAccessoryView = toolBar
        dfpMRect = DFPBannerView(adSize: kGADAdSizeMediumRectangle)
        dfpMRect.adUnitID = mRectAdUnitIDTextField.text
        dfpMRect.delegate = self
        dfpMRect.rootViewController = self
        mRectAdContainer.addSubview(dfpMRect)
    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if mRectAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(mRectAdUnitIDTextField.text, forKey: "DFPMRectAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        dfpMRect.load(DFPRequest())
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }

}

extension DFPMRectViewController : GADBannerViewDelegate
{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "DFP MRect did load")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "DFP MRect did fail to load with error: \(error.localizedDescription)")
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "DFP MRect will present screen")
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "DFP MRect will dismiss screen")
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "DFP MRect did dismiss screen")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        showAlertAction(withMessage: "View Controller will leave application")
    }
}

extension DFPMRectViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        mRectAdUnitIDTextField.text = content
    }
}
