//
//  CartViewModel.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 28/01/24.
//

import Foundation
import CoreData

class CartViewModel: ObservableObject {
    
    @Published var cartList : [ItemsEntity] = []
    @Published var cartData : [CartEntity] = []
    
    let manager = CoreDataManager.shared
    
    func getCartList() {
        let fetchRequest = NSFetchRequest<CartEntity>(entityName: "CartEntity")
        do {
            cartData = try manager.context.fetch(fetchRequest)
            if let totalItems = cartData.first?.items?.allObjects as? [ItemsEntity] {
                cartList = totalItems
            }
        } catch {
            print(error)
        }
    }
    
    func calculateTotal() -> Double {
        return cartList.compactMap{$0.price * Double($0.quantity)}.reduce(0, +)
    }
    
    func addItemQuantity(item: ItemsEntity) {
        if let cartFirst = cartData.first {
            item.quantity += 1
            cartFirst.addToItems(item)
        } else {
            let data = CartEntity(context: manager.context)
            item.quantity += 1
            data.addToItems(item)
        }
        manager.saveItem()
        getCartList()
    }
    
    func subItemQuantity(item: ItemsEntity) {
        if let cartFirst = cartData.first {
            item.quantity -= 1
            if item.quantity <= 0 {
                item.quantity = 0
                cartFirst.removeFromItems(item)
            }
        }
        manager.saveItem()
        getCartList()
    }
}
