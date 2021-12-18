//
//  storage.swift
//  BetterAuthenticator
//
//  Created by livingroot on 21.06.2021.

import Foundation

struct tokenst: Identifiable{
	var id:UUID = UUID();
	var token:String;
	var name:String;
	var order:Int = 0;
	var code:String = "";
}

final class storage: ObservableObject,Identifiable {
	@Published var tokens: [tokenst] = [tokenst]();
	static let shared = storage();
	private var keych = keychain();
	@Published var expired:Double = 1.0;
	var watch = WC();
	
	init(){
		
		self.load();
		reftimer();
	}
	func load(){
		let tmp = keych.getAll();
		if(tmp != nil){
			for i in 0 ... (tmp!.count - 1) {
				let token = tmp![i];
				
				if(token["key"] == nil || token["key"] as! String == ""){ continue; }

				let keyasid = UUID(uuidString: token["key"] as! String);
				if(keyasid == nil) { continue; } 
				
				var label: String = "";
				if(token["label"] != nil){ 
					label = token["label"] as! String;
				}
				//print(token)
				self.tokens.append(
					tokenst(
						id: keyasid!,
						token: token["value"] as! String,
						name: label,
						code: otp().gen(token["value"] as! String)
					)
				)
				
			}
		}
	}
	func reftimer(){ //updating codes
		let period:UInt64 = 30;
		var halfsecs = UInt64(Date().timeIntervalSince1970) / period; 
		var timeForNextPeriod = Date(timeIntervalSince1970: TimeInterval((halfsecs + 1) * period))
		var timediff:Double = 0;
		
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { ttt in
			if(Date() >= timeForNextPeriod){
				halfsecs = UInt64(Date().timeIntervalSince1970) / period; 
				timeForNextPeriod = Date(timeIntervalSince1970: TimeInterval((halfsecs + 1) * period))
				if(self.tokens.count == 0){ return; }
				for i in 0 ... (self.tokens.count - 1) {
					self.tokens[i].code = otp().gen(self.tokens[i].token);
				}
			}
			timediff = floor(timeForNextPeriod.timeIntervalSince1970 - Date().timeIntervalSince1970)
			self.expired = timediff/30;
		}
	}
	func add(key: UUID = UUID(), secret: String, label: String) -> Bool{
		if(secret == ""){ return false; }
		if(keych.set(key.uuidString, secret, label: label)){
			let newtoken = tokenst(id: key, token: secret, name: label, code: otp().gen(secret));
			self.tokens.append(newtoken);
			return true;
		} else { return false; }
	}
	func updLabel(id: UUID, newLabel: String, keychain: Bool = true) -> Bool{
		if(self.tokens.isEmpty){ return true; }
		for i in 0 ... (self.tokens.count - 1) {
			if(id == self.tokens[i].id){
				self.tokens[i].name = newLabel;
				break;
			}
		}
		if(keychain){
			return keych.updateLabel(key: id.uuidString, label: newLabel);
		} else { return true; }
	}
	func del(id: UUID, keychain:Bool = true){
		if(self.tokens.isEmpty){ return; }
		for i in 0 ... (self.tokens.count - 1) {
			if(id == self.tokens[i].id){
				self.tokens.remove(at: i);
				break;
			}
		}
		if(keychain){
			keych.del(key: id.uuidString);
		}
	}
	#if os(iOS)
	func addfromurl(url: URL){
		if(url.scheme == "otpauth" && url.host == "totp"){
			if(url.query != nil){
				var label = url.path;
				if(label != ""){
					label.removeFirst()
				}
				let secret = url.params()["secret"];
				if(secret == nil || secret == ""){ return; }
				
				let newid = UUID();
				_ = self.add(key: newid, secret: secret!, label: label);
				
				self.watch.send(["add": [[newid.uuidString, secret, label]]])
			}
		}
		//otpauth-migration://offline?data=CkkKIEtTUlRHMktTQTc0RUNQMjJCUlVZU0RFRUJNQzJHNzdIEhNraXR5YW5uekBFcGljIEdhbWVzGgpFcGljIEdhbWVzIAEoATACEAE%3D
	}
	#endif
}

extension URL {
	func params() -> [String:String] {
		var dict = [String:String]()

		if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
			if let queryItems = components.queryItems {
				for item in queryItems {
					dict[item.name] = item.value!
				}
			}
			return dict
		} else {
			return [:]
		}
	}
}
