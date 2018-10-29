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

class MoPubInterstitialViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var interstitialAdUnitIDTextField: UITextField!
    @IBOutlet weak var showAdButton: UIButton!
    
    var moPubInterstitial : MPInterstitialAdController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitialAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "MoPubInterstitialAdUnitID") != nil && UserDefaults.standard.object(forKey: "MoPubInterstitialAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "MoPubInterstitialAdUnitID") as? String : MOPUB_INTERSTITIAL_AD_UNIT_ID
        interstitialAdUnitIDTextField.inputAccessoryView = toolBar
        moPubInterstitial = MPInterstitialAdController (forAdUnitId: interstitialAdUnitIDTextField.text)
        moPubInterstitial.delegate = self
    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if interstitialAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(interstitialAdUnitIDTextField.text, forKey: "MoPubInterstitialAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        showAdButton.isHidden = true
        activityIndicator.startAnimating()
        moPubInterstitial.loadAd()
    }
    
    @IBAction func showAdTouchUpInside(_ sender: UIButton) {
        moPubInterstitial.show(from: self)
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
}

extension MoPubInterstitialViewController : MPInterstitialAdControllerDelegate
{
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        activityIndicator.stopAnimating()
        showAdButton.isHidden = false
        showAlertAction(withMessage: "MoPub Interstitial did load")
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!) {
        activityIndicator.stopAnimating()
        showAdButton.isHidden = true
        showAlertAction(withMessage: "MoPub Interstitial did fail load")
    }
    
    func interstitialWillAppear(_ interstitial: MPInterstitialAdController!) {
        showAlertAction(withMessage: "MoPub Interstitial will appear")
    }
    
    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
        showAlertAction(withMessage: "MoPub Interstitial did appear")
    }
    
    func interstitialWillDisappear(_ interstitial: MPInterstitialAdController!) {
        showAlertAction(withMessage: "MoPub Interstitial will disappear")
    }
    
    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        showAlertAction(withMessage: "MoPub Interstitial did disappear")
    }
    
    func interstitialDidExpire(_ interstitial: MPInterstitialAdController!) {
        showAlertAction(withMessage: "MoPub Interstitial did expire")
    }
    
    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        showAlertAction(withMessage: "MoPub Interstitial did receive tap event")
    }
}

extension MoPubInterstitialViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        interstitialAdUnitIDTextField.text = content
    }
}
