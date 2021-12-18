//
//  CodeList.swift
//  watch Extension
//
//  Created by Alex Lanser on 18.12.2021.
//

import SwiftUI

struct CodeList: View {

	var tokens:[tokenst];
	var expire:Double;

    var body: some View {
		ScrollView{
			ForEach(tokens){ token in
				if(expire > 0.1){
					Text(token.code.group(3))
						.font(.title)
						.gradientForeground([Color.green, Color.blue], expire - 0.1)
						.padding(.vertical, 1)
				} else {
					Text(token.code.group(3))
						.font(.title)
						.foregroundColor(.red)
						.padding(.vertical, 1)
				}
				Text(token.name)
					.font(.caption2)
					.foregroundColor(.gray)
					.padding(.bottom, 4)
				Divider()
			}
		}
	}
}
