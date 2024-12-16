//
//  HistoryViewController.swift
//  GroupVault Share
//
//  Created by Unique Consulting Firm on 04/12/2024.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noRecordlb: UILabel!
    
    var transactions: [AssignPayment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the table view cell
        tableview.delegate = self
        tableview.dataSource = self
        noRecordlb.isHidden = true
        // Load transactions from UserDefaults
        loadTransactionsFromUserDefaults()
    }
    
    private func loadTransactionsFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "AssignPayment") {
            do {
                transactions = try decoder.decode([AssignPayment].self, from: data)
                tableview.reloadData() // Reload table view after loading data
            } catch {
                print("Failed to load transactions: \(error)")
            }
        }
        
        if transactions.count == 0
        {
            noRecordlb.isHidden = false
        }
    }
    
    private func saveTransactionsToUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(transactions)
            UserDefaults.standard.set(data, forKey: "AssignPayment")
        } catch {
            print("Failed to save transactions: \(error)")
        }
        
        if transactions.count == 0
        {
            noRecordlb.isHidden = false
        }
    }
    
    @IBAction func removeAllPressed(_ sender:UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "AssignPayment")
        tableview.reloadData()
        if transactions.count == 0
        {
            noRecordlb.isHidden = false
        }
    }
    
    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    // Configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? historyTableViewCell else {
            return UITableViewCell()
        }
        
        // Get the transaction for this row
        let transaction = transactions[indexPath.row]
        
        // Populate the cell with transaction data
        cell.name.text = transaction.name
        cell.amount.text = "$ \(transaction.amount)"
        cell.status.text =  "\(transaction.status) \(transaction.method)"
        cell.date.text = formatDate(transaction.dateTime)
        
        if transaction.status == "Paid"
        {
            cell.status.backgroundColor = .green
        }
        else
        {
            cell.status.backgroundColor = .red
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Remove the transaction from the data source
                transactions.remove(at: indexPath.row)
                
                // Save updated transactions to UserDefaults
                saveTransactionsToUserDefaults()
                
                // Delete the row from the table view
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    
    // Optional: Row selection handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = transactions[indexPath.row]
        print("Selected transaction: \(transaction.name)")
    }
    
    // Helper function to format date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
