//
//  EditView.swift
//  BetterAuthenticator
//
//  Created by livingroot on 24.06.2021.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	let tokensdb = storage.shared;
	
	var tokenid:UUID;
	@State var label:String;
	@State var ShowDeleteAlert = false;
    var body: some View {
        VStack(spacing: 0.0){
			Group{
				Text("⬤⬤⬤  ⬤⬤⬤")
					.font(.system(size: 34))
					.foregroundColor(.gray)
				Text(label)
					.foregroundColor(.gray)
			}.padding()
			TextField("Label", text: $label)
				.padding(12)
				.background(Color("inputColor"))
				.padding(.vertical,6)
			Spacer()
			Button(action:{
				_ = tokensdb.updLabel(id: tokenid, newLabel: label)
				tokensdb.watch.send(["updlabel": [ tokenid.uuidString, label]])
				presentationMode.wrappedValue.dismiss()
			}){
				Text("Save")
					.frame(width: 120, height: 46, alignment: .center)
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(8.0)
					.padding()
			}
		}.navigationBarItems(trailing: 
			Button(action: { ShowDeleteAlert.toggle(); }){
				Image(systemName: "trash")
					.foregroundColor(.red)
					.padding(.horizontal, 4)
			}
		).navigationTitle("Edit")
		.alert(isPresented: $ShowDeleteAlert, content: {
			Alert(
				title: Text("WARNING"),
				message: Text("Before you remove this account, make sure that you can sign in to your account. This action can't be undone."),
				primaryButton: .destructive(Text("Remove")){
					tokensdb.del(id: tokenid);
					tokensdb.watch.send(["remove": tokenid.uuidString])
					presentationMode.wrappedValue.dismiss()
				},
				secondaryButton: .default(Text("Cancel")){
					ShowDeleteAlert = false;
				}
			)
		})
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(tokenid:UUID(), label: "test")
    }
}
