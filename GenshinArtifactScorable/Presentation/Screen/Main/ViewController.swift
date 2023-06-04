//
//  ViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/02/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var uidTextField: UITextField! {
        didSet {
            uidTextField.keyboardType = .numberPad
            
            let toolBar = UIToolbar()
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButtonDidTap))
            
            toolBar.items = [space, done]
            toolBar.sizeToFit()
            
            uidTextField.inputAccessoryView = toolBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        uidTextField.resignFirstResponder()
    }
    
    @objc func doneButtonDidTap() {
        uidTextField.resignFirstResponder()
    }
    
    @IBAction func uidSendButtonDidTap(_ sender: Any) {
        let uid = uidTextField.text!
        let viewController = SelectCharacterViewController(with: uid)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
