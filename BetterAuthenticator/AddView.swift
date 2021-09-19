//
//  ReadView.swift
//  BetterAuthenticator
//
//  Created by livingroot on 15.06.2021.
//

import SwiftUI

struct ReadView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	let tokensdb = storage.shared;
	@State var token = "";
	@State var tokenName = "";
	
	var body: some View{
		VStack(spacing: 0.0){
			Text("Only time based tokens")
				.font(.caption)
				.foregroundColor(Color.gray).padding()
			TextField("Token", text: $token)
				.padding(12)
				.background(Color("inputColor"))
				.padding(.vertical,6)
			TextField("Label", text: $tokenName)
				.padding(12)
				.background(Color("inputColor"))
				.padding(.vertical,6)
			Spacer()
			Button(action:{
				if(token == ""){ return; }
				let id = UUID();
				_ = tokensdb.add(key:id,secret: token, label: tokenName);
				tokensdb.watch.send(["add":[[id.uuidString,token,tokenName]]])
				self.presentationMode.wrappedValue.dismiss()
			}){
				Text("Add")
					.frame(width: 120, height: 46, alignment: .center)
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(8.0)
					.padding()
			}
		}.navigationTitle("Add manually")
	}
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        ReadView()
    }
}
