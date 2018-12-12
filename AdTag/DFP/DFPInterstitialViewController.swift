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

class DFPInterstitialViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var interstitialAdUnitIDTextField: UITextField!
    @IBOutlet weak var showAdButton: UIButton!
    
    var interstitial: DFPInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitialAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "DFPInterstitialAdUnitID") != nil && UserDefaults.standard.object(forKey: "DFPInterstitialAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "DFPInterstitialAdUnitID") as? String : DFP_INTERSTITIAL_AD_UNIT_ID
        interstitialAdUnitIDTextField.inputAccessoryView = toolBar

    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if interstitialAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(interstitialAdUnitIDTextField.text, forKey: "DFPInterstitialAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        showAdButton.isHidden = true
        activityIndicator.startAnimating()
        interstitial = DFPInterstitial(adUnitID: interstitialAdUnitIDTextField.text!)
        interstitial.delegate = self
        let request = DFPRequest()
        interstitial.load(request)
    }
    
    @IBAction func showAdTouchUpInside(_ sender: UIButton) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }

}

extension DFPInterstitialViewController : GADInterstitialDelegate
{
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        activityIndicator.stopAnimating()
        showAdButton.isHidden = false;
        showAlertAction(withMessage: "DFP Interstitial did load")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        activityIndicator.stopAnimating()
        showAdButton.isHidden = true
        showAlertAction(withMessage: "DFP Interstitial did fail to load with error: \(error.localizedDescription)")
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        showAlertAction(withMessage: "View Controller will leave application")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        showAdButton.isHidden = true
    }
}

extension DFPInterstitialViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        interstitialAdUnitIDTextField.text = content
    }
}
