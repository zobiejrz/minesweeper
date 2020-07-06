import SwiftUI

struct myView: View {
    var body: some View {
        
        VStack {
            Text("Paused")
                .font(.largeTitle)
                .foregroundColor(.primary)
            
            Button(action: {
                print("TODO: Resume")
            })
            {
                Text("Resume")
            }
            Button(action: {
                print("TODO: Restart")
            })
            {
                Text("Restart")
            }
            Button(action: {
                print("TODO: New Game")
            })
            {
                Text("New Game")
            }
            Button(action: {
                print("TODO: How to Play")
            })
            {
                Text("How to Play")
            }
            Button(action: {
                print("TODO: Quit")
            })
            {
                Text("Quit")
            }
            
        }
        .font(.title)
        .foregroundColor(.secondary)
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        myView()
    }
}

