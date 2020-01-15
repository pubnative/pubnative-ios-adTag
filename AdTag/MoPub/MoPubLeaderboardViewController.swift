//
//  Copyright © 2019 PubNative. All rights reserved.
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

class MoPubLeaderboardViewController: BaseViewController {
    
    @IBOutlet weak var leaderboardAdContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leaderboardAdUnitIDTextField: UITextField!
    
    var moPubLeaderboard : MPAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardAdUnitIDTextField.text = (UserDefaults.standard.object(forKey: "MoPubLeaderboardAdUnitID") != nil && UserDefaults.standard.object(forKey: "MoPubLeaderboardAdUnitID") as? String != "") ? UserDefaults.standard.object(forKey: "MoPubLeaderboardAdUnitID") as? String : MOPUB_LEADERBOARD_AD_UNIT_ID
        leaderboardAdUnitIDTextField.inputAccessoryView = toolBar
        moPubLeaderboard = MPAdView(adUnitId: leaderboardAdUnitIDTextField.text, size: kMPPresetMaxAdSize90Height)
        moPubLeaderboard.delegate = self
        moPubLeaderboard.stopAutomaticallyRefreshingContents()
        leaderboardAdContainer.addSubview(moPubLeaderboard)
    }
    
    @IBAction func saveAdUnitIDTouchUpInside(_ sender: UIButton){
        if leaderboardAdUnitIDTextField.text != nil {
            UserDefaults.standard.set(leaderboardAdUnitIDTextField.text, forKey: "MoPubLeaderboardAdUnitID")
            showAlertAction(withMessage: "Ad Unit ID Saved")
        }
    }
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        moPubLeaderboard.adUnitId = leaderboardAdUnitIDTextField.text
        moPubLeaderboard.loadAd()
    }
    
    @IBAction func scanQRCodeTouchUpInside(_ sender: UIButton) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
    
}

extension MoPubLeaderboardViewController : MPAdViewDelegate
{
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    func adViewDidLoadAd(_ view: MPAdView!) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "MoPub Leaderboard did load")
    }
    
    func adViewDidFail(toLoadAd view: MPAdView!) {
        activityIndicator.stopAnimating()
        showAlertAction(withMessage: "MoPub Leaderboard did fail to load")
    }
    
    func willLeaveApplication(fromAd view: MPAdView!) {
        showAlertAction(withMessage: "View Controller will leave application")
    }
}

extension MoPubLeaderboardViewController : ScannerViewControllerDelegate
{
    func scannerDetectedQRCode(withContent content: String) {
        leaderboardAdUnitIDTextField.text = content
    }
}
