//
//  ContentView.swift
//  BasicProject
//
//  Created by Manuel Lehé on 10.08.22.
//

import SwiftUI

struct ContentView: View {
    @State var subjectId: String = "debug"
    @State var subjectSet: Bool = false
    @State var debug: Bool = false
    
    var body: some View {
        if(debug){
            DebugView(subjectId: $subjectId,debug: $debug)
        }else if(subjectSet){
            RoutingView(subjectId: $subjectId, subjectSet: $subjectSet)
        }else{
            StartView(subjectId: $subjectId, subjectSet: $subjectSet,debug: $debug)
        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
