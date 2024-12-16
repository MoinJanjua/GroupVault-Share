//
//  AddmemberViewController.swift
//  GroupVault Share
//
//  Created by Unique Consulting Firm on 03/12/2024.
//

import UIKit

class AddmemberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var shareAmountTF: UITextField!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var datetf: UIDatePicker!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var method: DropDown!
    @IBOutlet weak var otherr: UITextField!
    @IBOutlet weak var recordbtn: UIButton!

    var transactions: [Transaction] = []
    var isFromList = false
    var selectedTransactionId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: recordbtn)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)

        self.method.placeholder = "Select Method"
        method.optionArray = ["By Cash", "By Online", "By Cheque", "Others"]
        method.didSelect { (selectedText, index, id) in
            self.method.text = selectedText
        }
        method.delegate = self

        if isFromList {
            loadSingleTransactionsFromUserDefaults()
        }
        else
        {
            loadTransactionsmUserDefaults()
        }
    }
    
    private func loadTransactionsmUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "transactions") {
            do {
                transactions = try decoder.decode([Transaction].self, from: data)
            } catch {
                print("Failed to load transactions: \(error)")
            }
        }
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // Load details of the transaction to edit
    private func loadSingleTransactionsFromUserDefaults() {
        guard let transaction = transactions.first(where: { $0.Id == selectedTransactionId }) else { return }
        
        NameTF.text = transaction.name
        contactTF.text = transaction.conntactno
        amount.text = transaction.amount
        method.text = transaction.method
        datetf.date = transaction.dateTime
        otherr.text = transaction.other
        shareAmountTF.text = transaction.shareamount
    }

    // Add or update record
    @IBAction func addRecordbtn() {
        var status = "Pending"
        guard let name = NameTF.text, !name.isEmpty,
              let contact = contactTF.text, !contact.isEmpty,
              let amountText = amount.text, !amountText.isEmpty,
              let methodText = method.text, !methodText.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        let date = datetf.date
        let other = otherr.text ?? ""
        let shareAmount = shareAmountTF.text ?? "0"

        if Int(amountText) ?? 01211221212 == Int(shareAmount) ?? 0 {
            status = "Paid"
        }

        if isFromList {
            // Update existing transaction
            if let index = transactions.firstIndex(where: { $0.Id == selectedTransactionId }) {
                transactions[index].name = name
                transactions[index].conntactno = contact
                transactions[index].amount = amountText
                transactions[index].method = methodText
                transactions[index].dateTime = date
                transactions[index].other = other
                transactions[index].status = status
                transactions[index].shareamount = shareAmount
            }
            showAlert(message: "Record updated successfully!")
        } else {
            // Add a new transaction
            let transactionId = UUID().uuidString
            let newTransaction = Transaction(
                amount: amountText, 
                shareamount: shareAmount,
                conntactno: contact,
                method: methodText,
                dateTime: date,
                name: name,
                other: other,
                status: status,
                Id: transactionId
            )
            transactions.append(newTransaction)
            showAlert(message: "Record added successfully!")
        }

        saveTransactionsToUserDefaults()
        clearFields()
    }

    // Save transactions to UserDefaults
    private func saveTransactionsToUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(transactions)
            UserDefaults.standard.set(data, forKey: "transactions")
        } catch {
            print("Failed to save transactions: \(error)")
        }
    }

    // Clear input fields
    private func clearFields() {
        NameTF.text = ""
        contactTF.text = ""
        amount.text = ""
        method.text = ""
        otherr.text = ""
        datetf.setDate(Date(), animated: false)
    }

    // Show an alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
}
