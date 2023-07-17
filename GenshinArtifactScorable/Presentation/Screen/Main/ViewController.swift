//
//  ViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/02/01.
//

import UIKit
import ReusableKit

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
    
    private var accountService = AccountService()
    private var cashedAccounts: [ShapedAccountAllInfo] = []
    
    @IBOutlet weak var searchHistoryTableView: UITableView! {
        didSet {
            searchHistoryTableView.dataSource = self
            searchHistoryTableView.delegate = self
            searchHistoryTableView.register(SearchHistoryTableViewCell.reusable)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cashedAccounts = accountService.getAllAccountsFromRealm()
        cashedAccounts.sort(by: { $0.searchDate ?? Date() > $1.searchDate ?? Date() })
        searchHistoryTableView.reloadData()
    }
    
    private func transitionToSelectCharacterViewController(uid: String) {
        let viewController = SelectCharacterViewController(with: uid)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        uidTextField.resignFirstResponder()
    }
    
    @objc func doneButtonDidTap() {
        uidTextField.resignFirstResponder()
    }
    
    @IBAction func uidSendButtonDidTap(_ sender: Any) {
        let uid = uidTextField.text!
        transitionToSelectCharacterViewController(uid: uid)
    }
}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cashedAccounts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchHistoryTableView.dequeue(SearchHistoryTableViewCell.reusable, for: indexPath)
        cell.inject(cashedAccounts[indexPath.row])
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        uidTextField.resignFirstResponder()
        
        let account = cashedAccounts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        transitionToSelectCharacterViewController(uid: account.uid)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        uidTextField.resignFirstResponder()
    }
}
