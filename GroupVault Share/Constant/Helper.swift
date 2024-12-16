//
//  Helper.swift
//  ImageEditot
//
//  Created by Unique Consulting Firm on 24/04/2024.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UILabel {

    @IBInspectable var borderWidth2: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius2: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor2: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UIView {

    @IBInspectable var borderWidth1: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius1: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor1: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

func roundCorner(button:UIButton)
{
    button.layer.cornerRadius = button.frame.size.height/2
    button.clipsToBounds = true
}


struct Transaction: Codable,Equatable {
    var amount: String
    var shareamount: String
    var conntactno: String // "Income" or "Expense"
    var method: String
    var dateTime: Date
    var name:String
    var other:String
    var status:String
    var Id: String
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
           return lhs.amount == rhs.amount &&
               lhs.shareamount == rhs.shareamount &&
               lhs.conntactno == rhs.conntactno &&
               lhs.method == rhs.method &&
               lhs.dateTime == rhs.dateTime &&
               lhs.name == rhs.name &&
               lhs.other == rhs.other &&
               lhs.status == rhs.status &&
               lhs.Id == rhs.Id
       }
}

struct AssignPayment: Codable,Equatable {
    var amount: String
    var method: String
    var dateTime: Date
    var name:String
    var other:String
    var status:String
    var Id: String
    var memberId: String
    
    static func == (lhs: AssignPayment, rhs: AssignPayment) -> Bool {
           return lhs.amount == rhs.amount &&
               lhs.method == rhs.method &&
               lhs.dateTime == rhs.dateTime &&
               lhs.name == rhs.name &&
               lhs.other == rhs.other &&
               lhs.status == rhs.status &&
               lhs.Id == rhs.Id &&
                lhs.memberId == rhs.memberId
       }
}


var currency = ""

func formatAmount(_ amount: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    
    // Convert amount to a number
    if let number = formatter.number(from: amount) {
        return formatter.string(from: number) ?? amount
    } else {
        // If conversion fails, assume there's no dot and add two zeros after it
        let amountWithDot = amount + ".00"
        return formatter.string(from: formatter.number(from: amountWithDot)!) ?? amountWithDot
    }
}

extension UIViewController
{
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


func addDropShadow(to view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 2.0
    view.layer.shadowOffset = CGSize(width: 0, height: 4)
    view.layer.shadowRadius = 8
    view.layer.masksToBounds = false               // Ensure shadow appears outside the view bounds
  }
