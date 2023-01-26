//
//  watch.swift
//  BetterAuthenticator
//
//  Created by livingroot on 26.06.2021.
//

import Foundation
import WatchConnectivity

class WC: NSObject, WCSessionDelegate, ObservableObject{
	var session: WCSession
	
    init(session: WCSession = .default){
		self.session = session
		super.init()
		if(WCSession.isSupported()){
			self.session.delegate = self
			session.activate()
		}
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		//if activationState == .activated {
            // Send what you need to the Watch
		//}
		#if os(watchOS)
		if activationState == .activated && storage.shared.tokens.isEmpty {
			self.send(["ask": "ask"]) 
		}
		#endif
    }
    
    public func send(_ message: [String: Any]){
		if(!WCSession.isSupported()){
			return;
		}
		
		self.session.sendMessage(message, replyHandler: nil)
	}
	
    #if os(iOS)
    
    func sessionDidBecomeInactive(_ session: WCSession) {
		//print("didbecomeinactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //print("inactivate")
    }
    
	func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
		DispatchQueue.main.async {
			if(message["ask"] != nil){
				let tokensindb = storage.shared.tokens;
				var tokens:[[String]] = [[String]]();
				
				for i in 0 ... (tokensindb.count - 1){
					let token = tokensindb[i];
					tokens.append([token.id.uuidString,token.token,token.name])
				}
				//print(tokens)
				self.send(["add": tokens])
			}
		}
	}
	
    #elseif os(watchOS)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
			print(message)
			if(message["add"] != nil){
				let newtokens:[[String]] = message["add"] as! [[String]];
				for i in 0...(newtokens.count - 1){
					let newtoken = newtokens[i];
					storage.shared.tokens.append(
						tokenst(
							id: UUID(uuidString: newtoken[0]) ?? UUID(),
							token: newtoken[1],
							name: newtoken[2],
							order: 0,
							code: otp().gen(newtoken[1])
						)
					);
				}
			} else if(message["remove"] != nil){
				let tmp = message["remove"] as! String
				let id = UUID(uuidString: tmp);
				if(id != nil) {
					storage.shared.del(id: id!,keychain:false)
				}
			} else if(message["updlabel"] != nil){
				let tmp = message["updlabel"] as! [String]
				let id = UUID(uuidString: tmp[0]);
				if(id != nil) {
					_ = storage.shared.updLabel(id:id!,newLabel:tmp[1] ,keychain:false)
				}
			}
		}
	}
    #endif
}
