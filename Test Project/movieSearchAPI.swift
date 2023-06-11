//
//  movieSearchAPI.swift
//  Test Project
//
//  Created by Harshit Agarwal on 11/06/23.
//
import AuthenticationServices
import SwiftUI

struct Movie: Codable,Hashable {
    let id: Int
    let original_title: String?
    let poster_path: String?
    let release_date: String?
    let title: String
}

struct discoverMovieResponse: Codable{
    let results: [Movie]
}
struct searchMovieResponse: Codable{
    let results: [Movie]
}


struct movieSearchAPI: View {
    @State private var searchText = ""
    
    @State private var discover = [Movie]()
    @State private var searched = [Movie]()

    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)){
                    ForEach(filteredMovies,id: \.self){movie in
                        if(movie.poster_path != nil){
                            
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300_and_h450_bestv2\(movie.poster_path!)"), scale: 1){image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 140)
                                    
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search for shows")
            .onChange(of: searchText) { newValue in
               
                search(with: newValue)
            }
            .task {
                await getDiscoverMovie()
            }
            .padding(.horizontal)
            .toolbar(){
                Menu{
                    Button("\(UserDefaults.standard.string(forKey: "firstName") ?? "N/A") \(UserDefaults.standard.string(forKey: "lastName") ?? "N/A")"){
                        
                    }
                    Button("Sign out"){
                        UserDefaults.standard.removeObject(forKey: "userID")
                        UserDefaults.standard.removeObject(forKey: "email")
                        UserDefaults.standard.removeObject(forKey: "firstName")
                        UserDefaults.standard.removeObject(forKey: "lastName")
                    }
                }label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                }
            }
        }
    }
    func getDiscoverMovie() async {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=025a0d7f62fd8db82c410f6dad7059bd&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        do{
            let (data,_) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(discoverMovieResponse.self, from: data){
                discover = decodedResponse.results
            }
        }catch{
            print("invalid data")
        }
    }
    func search(with query: String){
        Task{
            do{
                guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
                guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=025a0d7f62fd8db82c410f6dad7059bd&query=\(query)") else { return }
                
                
                let (data,_) = try await URLSession.shared.data(from: url)
                
                if let decodedResponse = try? JSONDecoder().decode(searchMovieResponse.self, from: data){
                    searched = decodedResponse.results
                }
            }catch{
                print("invalid data")
            }
        }
    }
    
    var filteredMovies: [Movie]{
        if searchText.isEmpty{
            return discover
        }else{
            return searched
            
        }
    }
}

struct movieSearchAPI_Previews: PreviewProvider {
    static var previews: some View {
        movieSearchAPI()
    }
}
