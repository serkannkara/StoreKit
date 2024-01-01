//
//  PaymentVC.swift
//  StoreKit
//
//  Created by Serkan on 31.12.2023.
//

import UIKit
import StoreKit

class PaymentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func oneDayPurchaseButtonAction(_ sender: Any) {
        paymentMethod(product: .oneday)
    }
    
    @IBAction func oneWeekPruchaseButtonAction(_ sender: Any) {
        paymentMethod(product: .oneweek)
    }
    
    @IBAction func monthlySubscriptionButtonAction(_ sender: Any) {
        paymentMethod(product: .monthly)
    }
    
    func paymentMethod(product: SubscriptionProduct) {
        if SKPaymentQueue.canMakePayments() {
            let set: Set<String> = [product.rawValue]
            let productRequest = SKProductsRequest(productIdentifiers: set)
            productRequest.delegate = self
            productRequest.start()
        }
    }
}

extension PaymentVC {
    enum SubscriptionProduct: String, CaseIterable {
        case oneday = "com.codefabrika.oneday"
        case oneweek = "com.codefabrika.oneweek"
        case monthly = "com.codefabrika.monthly"
    }
}

extension PaymentVC: SKPaymentTransactionObserver, SKProductsRequestDelegate {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .deferred:
                break
            case .restored:
                break
            default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            self.purchaseProduct(product: product)
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
}
