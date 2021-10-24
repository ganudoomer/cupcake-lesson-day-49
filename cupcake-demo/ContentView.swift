//
//  ContentView.swift
//  cupcake-demo
//
//  Created by Sree on 24/10/21.
//

import SwiftUI
// Coding Keys
class User: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    @Published var name = "Sree Ganesh"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
}

struct Response : Codable {
    var results : [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}


struct ContentView: View {
    @State var results = [Result]()
    var body: some View {
        List(results,id:\.trackId) { item in
            VStack{
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
            
        }.onAppear(perform: {
            guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
                print("Invalid URL")
                return
            }
            let request  = URLRequest(url: url)
            URLSession.shared.dataTask(with: request){ data, reponse,   error in
            // Step 4
            // Main thread
            // Backgroud thread
            // Dispact que send to the Main thread
                if let data = data {
                    if let decodedResponse = try?  JSONDecoder().decode(Response.self,from:data) {
                        DispatchQueue.main.async {
                            self.results = decodedResponse.results
                        }
                        return
                    }
                }
                print("Fetch Failed: \(error?.localizedDescription ?? "Unknown error")")
            }.resume()
            
        })
    }
}


struct ContentView2: View {
    @State var username = ""
    @State var email = ""
    var body: some View {
        Form {
            Section {
                TextField("Username",text:$username)
                TextField("Email",text:$email)
            }
            Section {
                Button("Create acoount"){
                    print("Creating account..")
                }
            }.disabled(username.isEmpty || email.isEmpty)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
