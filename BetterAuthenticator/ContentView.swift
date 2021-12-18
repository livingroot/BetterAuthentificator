//
//  ContentView.swift
//  BetterAuthenticator
//
//  Created by livingroot on 15.06.2021.

import SwiftUI

struct ContentView: View {

	@ObservedObject var tokensdb = storage.shared;
	
	@State var copymsgshow:Bool = false;
	@State var editmode:Bool = false;
	
    var body: some View {
		NavigationView {
			VStack{
				codeList(
					tokens: tokensdb.tokens,
					expire: tokensdb.expired,
					editmode: editmode,
					copymsgshow: $copymsgshow
				)
				.navigationBarTitleDisplayMode(.automatic)
				.navigationBarItems(
				leading:
					Button(action: {
						editmode.toggle();
					}){
						if(!editmode){
							Image(systemName: "pencil").padding(.horizontal, 4)
						} else {
							Text("Done")
						}
					}.font(.system(size: 18.0)),
				trailing:
					HStack{
						NavigationLink(
							destination: ReadView(),
							label: {
								Image(systemName: "plus").padding(.horizontal, 4)
							}
						).font(.system(size: 18.0))
						NavigationLink(
							destination: ScannerView(),
							label: {
								Image(systemName: "qrcode").padding(.horizontal, 4)
							}
						).font(.system(size: 18.0))
					}
				)
				if(copymsgshow){
					copymsg().zIndex(10.0)
				}
			}
		}.onOpenURL { (url) in
			tokensdb.addfromurl(url: url);
		}.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct copymsg: View{
	var body: some View{
		Text("Copied")
			.padding(8)
			.shadow(radius: 5)
			.background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .bottomTrailing))
			.cornerRadius(16)
			.foregroundColor(.white)
			.padding()
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
		ContentView(tokensdb: tokensdb(), copymsgshow: true, editmode: false)
        ContentView(tokensdb: tokensdb(), copymsgshow: false, editmode: true)
        ContentView(tokensdb: tokensdb(), copymsgshow: true, editmode: false)
			.previewDevice("iPhone SE (2nd generation)")
        
    }
}

