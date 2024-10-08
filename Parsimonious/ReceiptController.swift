//
//  ReceiptController.swift
//  Parsimonious
//
//  Created by Nick Venanzi on 9/28/24.
//
import Foundation
import SwiftUI

class ReceiptController: ObservableObject {
    
    @Published var categories: Set<String> = Set(["Groceries", "Rent", "Transportation", "Entertainment", "Utilities"])
    @Published var receipts: [Receipt] = []
    
    var descriptionsToCategories: [String: String] = [:]
    
    init() {
        retrieveFromCache()
    }
    
    func retrieveFromCache() {
        let decoder = JSONDecoder()

        if let categoriesData = UserDefaults.standard.object(forKey: StorageKeys.CATEGORIES) as? [Data] {
            categories = Set()
            for data in categoriesData {
                if let category = try? decoder.decode(String.self, from: data) {
                    categories.insert(category)
                }
            }
        }
        
        if let receiptData = UserDefaults.standard.object(forKey: StorageKeys.RECEIPTS) as? [Data] {
            for data in receiptData {
                if let receipt = try? decoder.decode(Receipt.self, from: data) {
                    receipts.append(receipt)
                    descriptionsToCategories[receipt.description.lowercased()] = receipt.category
                }
            }
        }
    }
    
    func storeInCache() {
        let categoriesArray: [String] = Array(categories)
        let encoder = JSONEncoder()

        let categoriesData: [Data] = categoriesArray.map { category in
            return (try? encoder.encode(category)) ?? Data()
        }

        let receiptData: [Data] = receipts.map { receipt in
            return (try? encoder.encode(receipt)) ?? Data()
        }

        UserDefaults.standard.set(categoriesData, forKey: StorageKeys.CATEGORIES)
        UserDefaults.standard.set(receiptData, forKey: StorageKeys.RECEIPTS)
    }
    
    func addCategory(_ category: String) {
        categories.insert(category)
        storeInCache()
    }
    
    func removeCategory(_ category: String) {
        categories.remove(category)
        storeInCache()
    }
    
    func addReceipt(amount: Double, description: String, note: String?, category: String) {
        receipts.append(Receipt(date: ReceiptDate(), description: description, note: note, category: category, amount: amount))
        descriptionsToCategories[description.lowercased()] = category
        storeInCache()
    }
    
    func retrieveCategory(_ fromDescription: String) -> String? {
        if let category = descriptionsToCategories[fromDescription.lowercased()] {
            return category
        }
        return nil
    }
    
}

struct Receipt: Identifiable, Hashable, Codable {
    var id = UUID()
    var date: ReceiptDate
    var description: String
    var note: String?
    var category: String
    var amount: Double
}

struct ReceiptDate: Hashable, Comparable, Codable, Equatable {
    
    var year: Int
    var month: Int
    var day: Int
    
    /*
     Default initializer creates an AnswerDate object associated with today's date
     */
    init() {
        let pieces = Date().description.split(separator: " ")[0].split(separator: "-")
        self.year = Int(String(pieces[0])) ?? 0
        self.month = Int(String(pieces[1])) ?? 0
        self.day = Int(String(pieces[2])) ?? 0
    }
    
    /*
     initializer creates an AnswerDate object associated with year/month/day
     */
    init(_ year: Int, _ month: Int, _ day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    static func < (lhs: ReceiptDate, rhs: ReceiptDate) -> Bool {
        // same year
        if (lhs.year == rhs.year) {
            // same month
            if (lhs.month == rhs.month) {
                return lhs.day < rhs.day
            }
            return lhs.month < rhs.month
        }
        return lhs.year < rhs.year
    }
    
    static func == (lhs: ReceiptDate, rhs: ReceiptDate) -> Bool {
        return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
    }
    
    static func yesterday() -> ReceiptDate {
        return ReceiptDate().dayBefore()
    }
    
    func dayBefore() -> ReceiptDate {
        let thirtyOne: Set<Int> = Set([1,3,5,7,8,10,12])
        let thirty: Set<Int> = Set([4,6,9,11])
        
        var yesterday = ReceiptDate(year, month, day - 1)
        
        if yesterday.day == 0 {
            yesterday.month -= 1
            if yesterday.month == 0 {
                yesterday.month = 12
                yesterday.year -= 1
            }
            if (thirtyOne.contains(yesterday.month)) {
                yesterday.day = 31
            } else if (thirty.contains(yesterday.month)) {
                yesterday.day = 30
            } else if (yesterday.year % 4 == 0) {
                yesterday.day = 29
            } else {
                yesterday.day = 28
            }
        }
        return yesterday
    }
    
    func dayAfter() -> ReceiptDate {
        let thirtyOne: Set<Int> = Set([1,3,5,7,8,10,12])
        
        var tomorrow = ReceiptDate(year, month, day + 1)
        
        if (
            (tomorrow.day > 31) ||
            (tomorrow.day > 30 && !thirtyOne.contains(tomorrow.month)) ||
            (tomorrow.day > 29 && tomorrow.month == 2) ||
            (tomorrow.day > 28 && tomorrow.month == 2 && tomorrow.year % 4 != 0)
        ) {
            tomorrow.day = 1
            tomorrow.month += 1
        }
        
        if tomorrow.month > 12 {
            tomorrow.month = 1
            tomorrow.year += 1
        }
        return tomorrow
    }
    
    static func fromString(_ dateString: String) -> ReceiptDate {
        let pieces = dateString.components(separatedBy: "-")
        return ReceiptDate(Int(pieces[0]) ?? 0, Int(pieces[1]) ?? 0, Int(pieces[2]) ?? 0)
    }
    
    func toString() -> String {
        return "\(year)-\(month)-\(day)"
    }
    
    func getMonthString() -> String {
        switch (month) {
            case 1:
                return "January"
            case 2:
                return "February"
            case 3:
                return "March"
            case 4:
                return "April"
            case 5:
                return "May"
            case 6:
                return "June"
            case 7:
                return "July"
            case 8:
                return "August"
            case 9:
                return "September"
            case 10:
                return "October"
            case 11:
                return "November"
            case 12:
                return "December"
            default:
                return "January"
        }
    }
}

struct StorageKeys {
    static var CATEGORIES = "Categories"
    static var RECEIPTS = "Receipts"
}
