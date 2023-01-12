//
//  StartView.swift
//  QuantiBike
//
//  Created by Manuel Lehé on 08.09.22.
//

import SwiftUI

struct StartView: View{
    @Binding var subjectId: String
    @Binding var subjectSet: Bool
    @Binding var debug: Bool
    var body: some View {
        HStack{
            VStack{
                Spacer()
                Text("QuantiBike").font(.largeTitle)
                Image("quantibike_icon_clear")
                    .resizable()
                    .scaledToFit()
                    .background(Color(red: 0.278, green: 0.349, blue: 0.153))
                    .cornerRadius(100.0)
                TextField("Subject ID", text: $subjectId)
                    .padding()
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                Button("Start Riding",action: {subjectSet = true})
                    .buttonStyle(.borderedProminent)
                    .padding(10)
                    .font(.headline)
                Button("Debug Mode",role:.destructive,action:{debug = true})
                    .font(.subheadline)
                Spacer()
            }
        }
    }
}
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(subjectId: .constant("Subject ID"), subjectSet: .constant(false),debug: .constant(false))
    }
}
