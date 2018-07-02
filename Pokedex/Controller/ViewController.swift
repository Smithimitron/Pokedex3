//
//  ViewController.swift
//  Pokedex
//
//  Created by Gavin Craft on 6/18/18.
//  Copyright © 2018 Gavin Craft. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    @IBOutlet weak var collection:UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    var musicPlayer:AVAudioPlayer!
    var pokemons=[Pokemon]()
    var filteredPokemon=[Pokemon]()
    var inSearchMode=false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchbar.returnKeyType = UIReturnKeyType.done
        collection.delegate=self
        collection.dataSource=self
        searchbar.delegate=self
        initAudio()
        parsePokemonCSV()
    }
    
    func parsePokemonCSV(){
        let path=Bundle.main.path(forResource: "pokemon", ofType: "csv")
        do{
            let stream = InputStream(fileAtPath: path!)!
            let csv = try! CSVReader(stream: stream)
            var rows = [[String]]()
            while let row = csv.next() {
                rows.append(row)
            }
            
            for row in rows{
                var id=row[0]
                var name = row[1]
                if id == "id"{
                    continue
                }
                else{
                    let poke=Pokemon(pokedexID: id)
                    poke.setName(name:name)
                    pokemons.append(poke)

                }
            }
            
        }catch let err as NSError{
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            var pokemon:Pokemon!
            
            if inSearchMode{
                pokemon=filteredPokemon[indexPath.row]
                cell.configurecell(pokemon:pokemon)
            }else{
                pokemon=pokemons[indexPath.row]
                cell.configurecell(pokemon:pokemon)
            }
            
            cell.configurecell(pokemon: pokemon)
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke:Pokemon!
        
        if inSearchMode{
            poke=filteredPokemon[indexPath.row]
        }else{
            poke=pokemons[indexPath.row]
        }
        performSegue(withIdentifier: "DetailSegue", sender: poke)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        }else{
            return pokemons.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:105,height:105)
    }
    func initAudio(){
        let path=Bundle.main.path(forResource: "music", ofType: "wav")!
        do{
            musicPlayer=try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    @IBAction func lol(_ sender: UIButton) {
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.4
        }else{
            musicPlayer.play()
            sender.alpha  = 1.0
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text==nil || searchbar.text==""{
            inSearchMode=false
            collection.reloadData()
            view.endEditing(true)
        }
        else{
            inSearchMode=true
            
            let lower=searchbar.text!.lowercased()
            filteredPokemon=pokemons.filter({$0.GETname().range(of: lower) != nil})
            collection.reloadData()
        }
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="DetailSegue"{
            if let dvc = segue.destination as? VC{
                if let poke=sender as? Pokemon{
                    dvc.pokemon=poke
                }
            }
        }
    }
}

