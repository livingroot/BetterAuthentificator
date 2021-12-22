//
//  settings.swift
//  BetterAuthenticator
//
//  Created by livingroot on 15.06.2021.
//

import SwiftUI

struct info: View {
	@AppStorage("firstrun") private var firstrun = true;
	
	let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    var body: some View {
		VStack{
			Spacer()
			Image("logo")
				.resizable()
				.scaledToFit()
				.frame(width:120.0, height: 120.0)
				.cornerRadius(100)
				.shadow(radius: 4)
			Text("v \(appVersion ?? "?")").foregroundColor(.gray)
			Text("Better Authentificator")
				.font(.title)
				.gradientForeground([Color.blue, Color.green], 0.0)
				.padding()
			VStack(alignment: .leading){
				Group{
					Divider()
					HStack{
						Image(systemName: "cloud.fill")
							.frame(width: 45)
						Text("Tokens are stored in iСloud keychain")
					}
					Divider()
				}
				Group{
					HStack{
						Image(systemName: "dollarsign.circle")
							.frame(width: 45)
						Text("Free & without ads")
					}
					Divider()
				}
				Group{
					HStack{
						Image(systemName: "applewatch")
							.frame(width: 45)
						Text("Apple Watch support")
					}
					Divider()
				}
				Spacer()
			}
			if(firstrun){
				Button(action: {
					firstrun = false;
				}){
					Text("OK")
						.padding(10)
						.frame(width: 110)
						.foregroundColor(.white)
						.background(Color.blue)
						.cornerRadius(7.0)
				}.padding()
			}
		}
    }
}

struct info_Previews: PreviewProvider {
    static var previews: some View {
        info()
    }
}
