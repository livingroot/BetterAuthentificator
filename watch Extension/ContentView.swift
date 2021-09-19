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
				ScrollView{
					ForEach(tokensdb.tokens){ token in
						if(tokensdb.expired > 0.2){
							Text(token.code.group(3))
								.font(.title)
								.gradientForeground([Color.green, Color.blue], tokensdb.expired - 0.2)
						} else {
							Text(token.code.group(3))
								.font(.title)
								.foregroundColor(.red)
						}
						Text(token.name)
							.font(.caption2)
							.foregroundColor(.gray)
						Divider()
					}
				}
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
			//ProgressView(value: 0.5)
		}.onChange(of: scenePhase) { newPhase in
			if newPhase == .active {
				if(!justloaded){
					tokensdb.tokens.removeAll();
					tokensdb.load();
				}
			} else if newPhase == .background {
				self.justloaded = false;
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
