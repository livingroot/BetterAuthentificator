//
//  keychain.swift
//  BetterAuthenticator
//
//  Created by livingroot on 19.06.2021.
//

import Foundation

class keychain {
	
	/* error codes:
	 -25299: duplicate
	 -50: Invalid attr
	 -25300: itemNotFound
	 -34018: missingEntitlement
	*/
	let isSync = kCFBooleanTrue;
	
	func set(_ key: String, _ value: String, label: String = "") -> Bool{
		let bundleid = Bundle.main.bundleIdentifier ?? "" 
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key.data(using: .utf8)!,
			kSecAttrComment as String: "TOTP token".data(using: .utf8)!,
			kSecAttrLabel as String: label.data(using: .utf8)!,
			kSecAttrSynchronizable as String: isSync!,
			kSecAttrService as String: bundleid.data(using: .utf8)!,
			//kSecAttrAccessGroup as String: bundleid.data(using: .utf8)!,
			kSecValueData as String: value.data(using: .utf8)!
		]
		let status = SecItemAdd(query as CFDictionary, nil)
		if(status != 0){
			print("Unable to add item to keychain \(status)")
			return false;
		}
		return true;
	}
	func get(_ key: String) -> String{	
		var ref: AnyObject?
		let query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrAccount as String: key.data(using: .utf8)!,
			kSecReturnAttributes: true,
			kSecMatchLimit: kSecMatchLimitOne,
			kSecAttrSynchronizable as String: isSync!,
			kSecReturnData: true
		] as CFDictionary
		let status = SecItemCopyMatching(query, &ref)
		if let result = ref as? NSDictionary, let passwordData = result[kSecValueData] as? Data {
			 //print(result)
			 let str = String(decoding: passwordData, as: UTF8.self)
			 print(str)
			 return str;
		}
		print("GET finished with status: \(status)")
		return "";
	}
	func getAll() -> [[String: Any]]?{
		//let bundleid = Bundle.main.bundleIdentifier ?? "" 
		var ref: AnyObject?
		let query = [
			kSecClass: kSecClassGenericPassword,
			//kSecAttrService as String: bundleid.data(using: .utf8)!,
			kSecAttrSynchronizable as String: isSync!,
			kSecMatchLimit: kSecMatchLimitAll,
			kSecReturnAttributes: true,
			kSecReturnData: true
		] as CFDictionary
		let status = SecItemCopyMatching(query, &ref)
		if let result = ref as? [[String: Any]]  {
			 let items = result.map { attributes -> [String: Any] in
				var item = [String: Any]()
				
				if let key = attributes[kSecAttrAccount as String] as? Data {
					item["key"] = String(data: key, encoding: .utf8)
				} else {
					item["key"] = ""
				}
				
				if let data = attributes[kSecValueData as String] as? Data {
					if let text = String(data: data, encoding: .utf8) {
						item["value"] = text
					} else  {
						item["value"] = data
					}
				}
				if let labelDat = attributes[kSecAttrLabel as String] as? Data {
					if let label = String(data: labelDat, encoding: .utf8) {
						item["label"] = label
					} else {
						item["label"] = ""
					}
				}
				if let synchronizable = attributes[kSecAttrSynchronizable as String] as? Bool {
					item["sync"] = synchronizable ? "true" : "false"
				}
				return item;
			 }
			 //print(items);
			 return items;
		}
		print("Operation finished with status: \(status)")
		return nil;
	}
	func updateLabel(key:String, label:String) -> Bool{
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key.data(using: .utf8)!,
			kSecAttrSynchronizable as String: isSync!,
		];
		let upd: [String: Any] = [
			kSecAttrLabel as String: label.data(using: .utf8)!
		];
		let status = SecItemUpdate(query as CFDictionary, upd as CFDictionary)
		if(status != 0) {
			print("Error while updating label \(status)")
			return false;
		}
		return true;
	}
	func update(key:String , upd: CFDictionary) -> Bool{
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key.data(using: .utf8)!,
			kSecAttrSynchronizable as String: isSync!,
		];
		let status = SecItemUpdate(query as CFDictionary, upd)
		if(status != 0) {
			print("Error while updating \(status)")
			return false;
		}
		return true;
	}
	func del(key: String){
		if(key == "") { return; }
		let query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrAccount as String: key.data(using: .utf8)!,
			kSecAttrSynchronizable as String: isSync!
		] as CFDictionary
		let status = SecItemDelete(query)
		if(status != 0){
			print("Error while deleting \(status)")
		}
		
	}
	
}
