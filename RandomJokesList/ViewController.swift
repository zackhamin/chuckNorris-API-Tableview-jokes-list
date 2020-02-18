//
//  ViewController.swift
//  RandomJokesList
//
//  Created by Ishaq Amin on 13/02/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //    Array for dummy data
    
    //    var jokes = ["Chuck Norris doesn't bug hunt as that signifies a probability of failure, he goes bug killing.","Chuck Norris once sued Burger King after they refused to put razor wire in his Whopper Jr, insisting that that actually is &quot;his&quot; way.","As President Roosevelt said: &quot;We have nothing to fear but fear itself. And Chuck Norris.&quot;","Chuck Norris doesn't have pubic hairs because hair doesn't grow on balls of steal.","Chuck Norris doesn't use reflection, reflection asks politely for his help.","Chuck Norris' first job was as a paperboy. There were no survivors.","Chuck Norris crossed the road. No one has ever dared question his motives.","Chuck Norris once pissed in a gas tank of a semi truck as a joke - that truck is now know as Optimus Prime.","Chuck Norris does not code in cycles, he codes in strikes.","Chuck Norris once pulled out a single hair from his beard and skewered three men through the heart with it."]
    
    @IBOutlet weak var tableView: UITableView!
    var changeURL = true
    var explicit = "limitTo=[nerdy,explicit]"
    var nonExplicit = "limitTo=[nerdy]"
    var randomJokeModel: JokesResponse?
    
    
    // MARK: - Welcome
    struct JokesResponse: Codable {
        let type: String
        let jokes: [Joke]
        
        enum CodingKeys: String, CodingKey {
            case type = "type"
            case jokes = "value"
        }
    }
    
    // MARK: - Value
    struct Joke: Codable {
        let id: Int
        let joke: String
        let categories: [String]
    }
    
    
    enum ApiError: Error {
        case noDateError
    }
    
    
    @IBAction func changeURL(_ sender: UISwitch) {
        if sender.isOn{
            changeURL = true
        } else {
            changeURL = false
        }
    }
    
    fileprivate func fetchJokesJSON(completion: @escaping (Result<JokesResponse, Error>) -> ()) {
        
        //        var urlNonExplicit = "http://api.icndb.com/jokes/limitTo=[nerdy]"
        //        var urlExplicit = "http://api.icndb.com/jokes/limitTo=[nerdy,explicit]"
        var urlString = "http://api.icndb.com/jokes/"
        
        if (changeURL == true) {
            urlString.append(nonExplicit)
        } else if (changeURL == false) {
            urlString.append(explicit)
        } else {
            return
        }
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        
        print(url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.noDateError))
                return
            }
            
            do {
                let jokes = try JSONDecoder().decode(JokesResponse.self, from:data)
                completion(.success(jokes))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        
        tableView.dataSource = self
        
        fetchJokesJSON { [weak self] (res) in
            DispatchQueue.main.async {
                switch res {
                case .success(let welcome):
                    self!.randomJokeModel = welcome
                    self?.tableView.reloadData()
                    // let jokes1 = [welcome.value.joke]
                    //                    print(welcome.value.joke)
                //print(jokes1)
                case .failure(let err):
                    print("Sorry, we are all laughed out! \(err)")
                }
            }
            
        }
        
    }
    
}
//extension ViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return jokes.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier:"jokeCell", for: indexPath)
//        cell.textLabel?.text = jokes[indexPath.row]
//        cell.textLabel?.numberOfLines = 0;
////        cell.textLabel?.sizeToFit()
//        return cell

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.randomJokeModel?.jokes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.randomJokeModel?.jokes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"jokeCell", for: indexPath)
        cell.textLabel?.text = model?.joke
        cell.textLabel?.numberOfLines = 0;
        return cell
        
    }
    
}

//value[0].joke


