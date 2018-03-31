//
//  CodeVerificationController.swift
//  Cheese
//
//  Created by Tien on 3/27/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class CodeVerificationController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var labelNo1: BorderedLabel!
    @IBOutlet weak var labelNo2: BorderedLabel!
    @IBOutlet weak var labelNo3: BorderedLabel!
    @IBOutlet weak var labelNo4: BorderedLabel!
    @IBOutlet weak var labelNo5: BorderedLabel!
    @IBOutlet weak var labelNo6: BorderedLabel!
    @IBOutlet weak var labelNo7: BorderedLabel!
    @IBOutlet weak var labelNo8: BorderedLabel!
    @IBOutlet weak var labelNo9: BorderedLabel!
    @IBOutlet weak var labelNo10: BorderedLabel!
    @IBOutlet weak var labelsContainerView: UIView!
    
    @IBOutlet weak var enterCodeView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    
    var labelArray = [UILabel]()
    
    let maxCodeLength = 10
    let urlCheckCode = "https://smagicproductions-1.herokuapp.com/codes"
    
    let maximumCodeSubmits = 5
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        labelArray = [labelNo1, labelNo2, labelNo3, labelNo4, labelNo5, labelNo6, labelNo7, labelNo8, labelNo9, labelNo10]
        
        let wrongCount = PersistentService.shared.getNumberOfInvalidCode()
        if (wrongCount == maximumCodeSubmits) {
            warningLabel.isHidden = false
            enterCodeView.isHidden = true
            
            warningLabel.text = "You have entered wrong code 5/5 times, you're not allowed to use this application"
        } else {
            warningLabel.isHidden = true
            enterCodeView.isHidden = false
            
            codeTextField.becomeFirstResponder()
            codeTextField.text = "";
            codeTextField.delegate = self
            codeTextField.addTarget(self, action: #selector(codeTextFieldDidChanged(textField:)), for: .editingChanged)
            
            let tapOnBackgroundGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap(_:)))
            view.addGestureRecognizer(tapOnBackgroundGesture)
            
            let tapOnLabelsContainerViewGesture = UITapGestureRecognizer(target: self, action: #selector(labelsContainerViewDidTap(_:)))
            labelsContainerView.addGestureRecognizer(tapOnLabelsContainerViewGesture)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func codeTextFieldDidChanged(textField: UITextField) {
        let code = textField.text ?? ""
        let codeLength = code.count
        for i in 0..<codeLength {
            let index = code.index(code.startIndex, offsetBy: i)
            labelArray[i].text = String(code[index]);
        }
        for i in codeLength..<maxCodeLength {
            labelArray[i].text = ""
        }
    }
    
    @IBAction func goButtonDidClick(_ sender: UIButton) {
        codeTextField.resignFirstResponder()
        
        let code = codeTextField.text ?? ""
        guard code.count == 10 else {
            return
        }
        
        print("Code \(code)")
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30 // 30 seconds.
        
        let params: Parameters = [
            "code": code,
            "uuid": "ios_uuid"
        ]
        
        showLoading(message: "Please wait")
        manager.request(urlCheckCode, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { [weak self] response in
            self?.showLoading(message: nil)
            
            if let error = response.error {
                self?.handleError(error: error as NSError)
            } else {
                if let jsonData = response.result.value as? [String:Any] {
                    print(jsonData)
                    self?.handleServerResponse(json: jsonData)
                } else {
                    self?.handleError(error: nil)
                }
            }
        }
    }
    
    func handleServerResponse(json: [String:Any]) {
        if let status = json["status"] as? Bool {
            print(status)
            // Status is true or false
            if status {
                // Moving to next screen.
                print("Verify code success")
                PersistentService.shared.setVerificationStatus(true)
                moveToHomeScreen()
            } else {
                var wrongCount = PersistentService.shared.getNumberOfInvalidCode()
                wrongCount += 1;
                PersistentService.shared.saveNumberOfInvalidCode(number: wrongCount)
                
                if (wrongCount >= maximumCodeSubmits) {
                    let alertController = UIAlertController(title: "Error", message: "You are not allowed to use this application", preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "You entered wrong code \(wrongCount)/\(maximumCodeSubmits) times, please try again", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            // Status is something else.
            handleError(error: nil)
        }
    }
    
    // Unknown error <=> error = nil
    func handleError(error: NSError?) {
        if let error = error {
            if (error.domain == NSURLErrorDomain) {
                let alertController = UIAlertController(title: "Error", message: "Cannot verify code, please check your internet connection and try again", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                // TODO: Handle other cases
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Unknown error, please try again later", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func moveToHomeScreen() {
        let homeVC = Utilities.getViewController(identifier: "HomeViewController")
        self.navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    func labelsContainerViewDidTap(_ sender: UIView?) {
        self.codeTextField.becomeFirstResponder()
    }
    
    func backgroundViewDidTap(_ sender: UIView?) {
        self.codeTextField.resignFirstResponder()
    }
    
    func showLoading(message: String?) {
        if let msg = message {
            if hud == nil {
                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            hud?.mode = .indeterminate
            hud?.label.text = msg
        } else {
            hud?.hide(animated: true)
        }
    }
}

extension CodeVerificationController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if (newText.count > maxCodeLength) {
            return false
        }
        return true
    }
}
