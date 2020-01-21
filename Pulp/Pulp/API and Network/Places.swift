//
//  Places.swift
//  Pulp
//
//  Created by Aryan Arora on 11/16/19.
//  Copyright © 2019 Pulp Inc. All rights reserved.
//
import Foundation
import Moya


struct MapReturn: Codable{
    let places: [Place]
}

struct PlaceSearch: Codable{
    let boolexists: Bool
    let place: Place
}

struct CreatePlaceResponse: Codable{
    let placeID: String
}

func GetMapPlaces() {

    service.request(.GetMap(userId: USERID)) {(result) in
    switch result {
    case .success(let response):
        let save = try? JSONDecoder().decode([GetMapResponse].self, from: response.data)
        MapResponseToPlace(list: save ?? MapConvert)
        print("Should be first!")
        mapDispatch.leave()
    case .failure(let error):
        print("Error: \(error)")
    }
}
    
}

func MapResponseToPlace(list:[GetMapResponse]){
    for place in list{
        let t = place.place
        let a = place.reviews
        var treviews = [Review]()
        for rev in a {
            if (rev.body != ""){
                treviews.insert(Review(postedBy: "", userImage: defaultURL, body: rev.body, rating: rev.rating), at: 0)
            }
        }
        
        let temp = Place(name: t.name, city: t.city, state: t.state, latitude: t.latitude, longitude: t.longitude, tags: t.tags, address1: t.address1, address2: t.address2, zip_code: t.zip_code, image: t.image, id: t._id, fbvisitors: place.friend_images, reviews: treviews, rating: place.averageRating, isDatabase: true)
        FriendPlaces.insert(temp, at: 0)
    }
    
}

func GetReviews(){
    
}

func ListToPlace(list:[PlacesList]){
        YelpSearch.removeAll()
        for place in list {
            var found = false
            var tags: [String] = [""]
            tags.removeAll()
            for t in place.categories{
                tags.append(t.title)
            }
            for (i,t) in FriendPlaces.enumerated(){
                if(t.name == place.name ){
                    YelpSearch.insert(FriendPlaces[i], at: 0)
                    found = true
                    break
                }
            }
                if(!found){   // Not in Database
                    YelpSearch.append(Place(name: place.name ?? "", city: place.location?.city ?? "", state: place.location?.state ?? "", latitude: place.coordinates.latitude, longitude: place.coordinates.longitude, tags: tags, address1: place.location?.address1, address2: place.location?.address2, zip_code: place.location?.zip_code, image: place.image_url, id: "", fbvisitors: [], reviews: [], rating: place.rating ?? 0, isDatabase: false))
                }
            
            }
        }
    

                 
//                service.request(.PlaceNameSearch(placeName: place.name ?? "")) {(result) in
//                    switch result {
//                    case .success(let response):
//                        let save = try? JSONDecoder().decode(GetMapResponse.self, from: response.data)
//                        print(save)
//                        if (save != nil ){ // Database Place
//                        let a = save ?? searchConvert
//                        let t = a.place
//                        temp = Place(name: t.name, city: t.city, state: t.state, latitude: t.latitude, longitude: t.longitude, tags: t.tags, address1: t.address1, address2: t.address2, zip_code: t.zip_code, image: t.image, id: t._id, fbvisitors: a.friend_images, reviews: [Review(postedBy: "2", userImage:defaultURL, body: "Fellow is a Great place", rating: 4), Review(postedBy: "3", userImage:defaultURL, body: "Going to Fellow is worth it", rating: 5)], rating: a.averageRating, isDatabase: true)
//                        YelpSearch.insert(temp, at: 0)
//                        }
//                        else{   // Not in Database
//                            YelpSearch.append(Place(name: place.name ?? "", city: place.location?.city ?? "", state: place.location?.state ?? "", latitude: place.coordinates.latitude, longitude: place.coordinates.longitude, tags: tags, address1: place.location?.address1, address2: place.location?.address2, zip_code: place.location?.zip_code, image: place.image_url, id: "", fbvisitors: [], reviews: [], rating: place.rating ?? 0, isDatabase: false))
//                        }
//
//                    case .failure(let error):
//                        print("Error: \(error)")
//                    }
//
//                }
            
//        }
//       print("Reached here")
//     searchDispatchGroup.leave()
//    }





func CreatePlace(place: Place) {
    service.request(.CreatePlace(name:place.name, city: place.city, state:place.state ,latitude:place.latitude ,longitude:place.longitude ,tags: place.tags,address1:place.address1 ?? "" ,address2: place.address2 ?? "" , zip_code: place.zip_code ?? "", image: place.image ?? "")) {(result) in
    switch result {
    case .success(let response):
        if var string = String(data: response.data, encoding: .utf8) {
            print("Get the place id here:")
            var range = string.index(string.endIndex, offsetBy: -18)..<string.endIndex
            string.removeSubrange(range)
            range = string.startIndex..<string.index(string.startIndex, offsetBy:10 )
            string.removeSubrange(range)
            print(string)
            place_id = string
        }
    case .failure(let error):
        print("Error: \(error)")
    }
}
}

func GetPlace(placeID: String) {
    service.request(.GetPlace(placeID: placeID )) {(result) in
    switch result {
    case .success(let response):
        print(try? JSONSerialization.jsonObject(with: response.data, options: []) as Any as Any)
    case .failure(let error):
        print("Error: \(error)")
    }
}
}