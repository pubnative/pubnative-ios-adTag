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
import MoPub

class MoPubMRectViewController: BaseViewController {
    
    @IBOutlet weak var mRectAdContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mRectAdUnitIDTextField: UITextField!
    
    var moPubMRect : MPAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mRectAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "MoPubMRectAdUnitID") != nil && UserDefaults.standard.object(forKey: "MoPubMRectAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "MoPubMRectAdUnitID") as? String : MOPUB_MRECT_AD_UNIT_ID
        mRectAdUnitIDTextField.inputAccessoryView = toolBar
        moPubMRect = MPAdView(adUnitId: mRectAdUnitIDTextField.text, size: MOPUB_MEDIUM_RECT_SIZE)
        moPubMRect.delegate = self
        moPubMRect.stopAutomaticallyRefreshingContents()
        mRectAdContainer.addSubview(moPubMRect)
    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if mRectAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(mRectAdUnitIDTextField.text, forKey: "MoPubMRectAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        moPubMRect.loadAd()
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
}

extension MoPubMRectViewController : MPAdViewDelegate
{
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    func adViewDidLoadAd(_ view: MPAdView!) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "MoPub MRect did load")
    }
    
    func adViewDidFail(toLoadAd view: MPAdView!) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "MoPub MRect did fail to load")
    }
    
    func willLeaveApplication(fromAd view: MPAdView!) {
        showAlertAction(withMessage: "View Controller will leave application")
    }
}

extension MoPubMRectViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        mRectAdUnitIDTextField.text = content
    }
}
