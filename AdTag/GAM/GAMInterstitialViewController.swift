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

class GAMInterstitialViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var interstitialAdUnitIDTextField: UITextField!
    @IBOutlet weak var showAdButton: UIButton!
    
    var interstitial: GAMInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitialAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "GAMInterstitialAdUnitID") != nil && UserDefaults.standard.object(forKey: "GAMInterstitialAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "GAMInterstitialAdUnitID") as? String : GAM_INTERSTITIAL_AD_UNIT_ID
        interstitialAdUnitIDTextField.inputAccessoryView = toolBar

    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if interstitialAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(interstitialAdUnitIDTextField.text, forKey: "GAMInterstitialAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        showAdButton.isHidden = true
        activityIndicator.startAnimating()
        let request = GAMRequest()
        GAMInterstitialAd.load(withAdManagerAdUnitID: interstitialAdUnitIDTextField.text!, request: request) { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            activityIndicator.stopAnimating()
            showAdButton.isHidden = false
            interstitial?.fullScreenContentDelegate = self
            showAlertAction(withMessage: "GAM Interstitial did load")
           }
    }
    
    @IBAction func showAdTouchUpInside(_ sender: UIButton) {
        do {
            try interstitial?.canPresent(fromRootViewController: self)
            if interstitial != nil {
                interstitial?.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }

}

extension GAMInterstitialViewController : GADFullScreenContentDelegate {
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        activityIndicator.stopAnimating()
        showAdButton.isHidden = true
        showAlertAction(withMessage: "GAM Interstitial did fail to load with error: \(error.localizedDescription)")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        showAdButton.isHidden = true
    }
}

extension GAMInterstitialViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        interstitialAdUnitIDTextField.text = content
    }
}
