//
//  ContentView.swift
//  watch Extension
//
//  Created by livingroot on 18.06.2021.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var tokensdb = storage.shared;
	@Environment(\.scenePhase) var scenePhase
	@State var justloaded = true;
	@State var loading = false;
	
    var body: some View {
        VStack{
			if(!tokensdb.tokens.isEmpty){
				CodeList(tokens: tokensdb.tokens, expire: tokensdb.expired)
			} else if(loading){
				Text("Loading...")
			} else {
				Text("Add token via iPhone app.")
				Spacer()
				if(justloaded){
					Button(action: {
						loading = true;
						tokensdb.watch.send(["ask": "ask"]);
					}){
						Text("Refresh")
					}
				} 
			}
		}.onChange(of: scenePhase) { newPhase in
			if newPhase == .active {
				if(!justloaded){
					tokensdb.tokens.removeAll();
					tokensdb.load();
				}
			} else if newPhase == .background {
				self.justloaded = false;
			}
		}.onAppear {
			if(tokensdb.tokens.isEmpty){
				tokensdb.watch.send(["ask": "ask"]);
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var tokensdb = { () -> storage in
		let dummy = storage();
		
		dummy.tokens.append(tokenst(token: "", name: "preview", code: "000000"))
		dummy.tokens.append(tokenst(token: "", name: "preview", code: "123456"))
		
		return dummy;
	};

    static var previews: some View {
		ContentView(tokensdb: tokensdb())
        
    }
}
