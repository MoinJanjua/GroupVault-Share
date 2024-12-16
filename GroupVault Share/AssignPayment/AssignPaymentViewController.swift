//
//  AssignPaymentViewController.swift
//  GroupVault Share
//
//  Created by Unique Consulting Firm on 04/12/2024.
//

import UIKit

class AssignPaymentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var method: DropDown!
    @IBOutlet weak var memberList: DropDown!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var other: UITextField!
    
    @IBOutlet weak var recordbtn: UIButton!
    
    var selectedId = String()
    var payment = [AssignPayment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: recordbtn)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        
        self.method.placeholder = "Select Method"
        method.optionArray = ["By Cash","By Online","By Cheque","Others"]
        method.didSelect{(selectedText , index ,id) in
            self.method.text = selectedText
        }
        method.delegate = self
        loadTransactionsFromUserDefaults()
        
        // Do any additional setup after loading the view.
    }
    
    
    private func loadAssignPaymentFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "AssignPayment") {
            do {
                payment = try decoder.decode([AssignPayment].self, from: data)
                print("success",payment)
               // Reload table view after loading data
            } catch {
                print("Failed to load transactions: \(error)")
            }
        }
        
    }

    
    private func loadTransactionsFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "transactions") {
            do {
                // Decode the transactions array
                let transactions = try decoder.decode([Transaction].self, from: data)
                
                // Extract names and IDs
                let nameAndIdList = transactions.map { transaction in
                    return ["name": transaction.name, "id": transaction.Id]
                }
                
                // Populate the dropdown with names
                let names = nameAndIdList.map { $0["name"] ?? "" }
                self.memberList.optionArray = names
                
                // Handle selection from the dropdown
                self.memberList.didSelect { (selectedText, index, _) in
                    self.memberList.text = selectedText
                    
                    // Retrieve the selected name's ID
                    var selectedId = nameAndIdList[index]["id"]
                    selectedId = selectedId
                    print("Selected ID: \(selectedId ?? "")")
                    
                    // You can now use `selectedId` as needed
                }
                
                print("Extracted name and id list: \(nameAndIdList)")
            } catch {
                print("Failed to load transactions: \(error)")
            }
        }
        loadAssignPaymentFromUserDefaults()
        // Set placeholder for the dropdown
        self.memberList.placeholder = "Select Member"
    }


    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func addRecordbtn()
    {
        
        guard let name = memberList.text, !name.isEmpty,
                    let amountText = amount.text, !amountText.isEmpty,
                    let methodText = method.text, !methodText.isEmpty
                    else
                    {
                  showAlert(message: "Please fill in all fields.")
                  return
              }
              
              let date = date.date
              let other = other.text ?? ""
              let transactionId = UUID().uuidString
              // Create a new Transaction object
              let newTransaction = AssignPayment(
                  amount: amountText,
                  method: methodText,
                  dateTime: date,
                  name: name,
                  other: other,
                  status: "Paid", // Default status
                  Id: transactionId,
                  memberId: selectedId
              )
              
              // Add the new transaction to the array
              payment.append(newTransaction)
              saveTransactionsToUserDefaults()
              // Show success message
              showAlert(message: "Record added successfully!")
              
              // Optionally, clear the fields
              clearFields()
    }
    
    
    private func saveTransactionsToUserDefaults() {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(payment)
                UserDefaults.standard.set(data, forKey: "AssignPayment")
            } catch {
                print("Failed to save transactions: \(error)")
            }
    }
    
    
    private func clearFields() {
            memberList.text = ""
            amount.text = ""
            method.text = ""
            other.text = ""
            date.setDate(Date(), animated: false)
        }
        
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
