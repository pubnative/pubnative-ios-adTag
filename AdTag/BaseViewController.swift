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

class BaseViewController : UIViewController {

    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBarAndDoneButton()
    }

    func createToolBarAndDoneButton() {
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem (barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        doneButton.tintColor = UIColor(red:0.45, green:0.16, blue:0.49, alpha:1.00)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func showAlertAction(withMessage message: String) {
        let alert = UIAlertController (title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String,
                                       message: message,
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction (title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
