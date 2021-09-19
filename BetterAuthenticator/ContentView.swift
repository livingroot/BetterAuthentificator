//
//  ContentView.swift
//  BetterAuthenticator
//
//  Created by livingroot on 15.06.2021.

import SwiftUI

struct ContentView: View {

	@ObservedObject var tokensdb = storage.shared;
	
	@State var copymsgshow = false;
	@State var editmode = false;
    var body: some View {
		NavigationView {
			VStack{
				List{
					ForEach(tokensdb.tokens){ token in
						VStack {
							if(!editmode){
								if(tokensdb.expired > 0.2){
									Text(token.code.group(3))
										.font(.system(size: 42))
										.gradientForeground([Color.green,Color.blue], tokensdb.expired - 0.2)
								} else {
									Text(token.code.group(3))
										.font(.system(size: 42))
										.foregroundColor(.red)
								}
							} else {
								HStack{
									NavigationLink(
										destination: EditView(tokenid: token.id, label: token.name)
									){
										Text(token.code.group(3))
									}.font(.system(size: 42))
									Spacer()
									//Image(systemName: "line.horizontal.3")
								}
							}
							if(token.name.count > 0){
								Text(token.name)
									.font(.footnote)
									.foregroundColor(Color.gray)
							}
							//Divider()
						}.frame(maxWidth: .infinity)
						//.listRowSeparator(.hidden)
						.onTapGesture {
							//self.action(false)
							if(editmode) { return; }
							UIPasteboard.general.string = token.code;
							if(!copymsgshow){
								copymsgshow = true;
								Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { ttt in
									copymsgshow = false;
									ttt.invalidate();
								}
							}
						}
					}//onMove
				}.listStyle(PlainListStyle())
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
					}.font(.title2),
				trailing:
					HStack{
						NavigationLink(
							destination: ReadView(),
							label: {
								Image(systemName: "plus").padding(.horizontal, 4)
							}
						).font(.title2)
						NavigationLink(
							destination: ScannerView(),
							label: {
								Image(systemName: "qrcode").padding(.horizontal, 4)
							}
						).font(.title2)
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

extension UIScreen{
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
   static let size = UIScreen.main.bounds.size
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

