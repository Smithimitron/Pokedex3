//
//  VC.swift
//  Pokedex
//
//  Created by Gavin Craft on 6/30/18.
//  Copyright © 2018 Gavin Craft. All rights reserved.
//

import UIKit

class VC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var moves:[String]!
    var correspondingDamages:[String]!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var moveView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var me: UIImageView!
    @IBOutlet weak var evoLBL: UILabel!
    @IBOutlet weak var attackLBL: UILabel!
    @IBOutlet weak var heightLBL: UILabel!
    @IBOutlet weak var weightLBL: UILabel!
    @IBOutlet weak var defenseLBL: UILabel!
    @IBOutlet weak var typeLBL: UILabel!
    @IBOutlet weak var evoMe: UIImageView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var function: UISegmentedControl!
    
    
    var pokemon:Pokemon!
    func loadAMoves(){
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon_moves", ofType: "csv")!)!
        let id = Int(pokemon.GETid())
        moves=[""]
        moves.remove(at: 0)
        correspondingDamages=[""]
        correspondingDamages.remove(at: 0)
        let csv = try! CSVReader(stream: stream)
        while let row = csv.next() {
            if row[0] == "pokemon_id"{
                print("\(row) got the continue block")
                continue
            }
            if row[0]==pokemon.GETid(){
                if row[1] == "1" {
                    moves.append(row[2])
                    correspondingDamages.append("LVL "+row[4])
                }else if row[1] == "2"{
                    break
                }
            }
            else if Int(row[0])!-1 >= id! {
                break
            }
            for i in 0...correspondingDamages.count-1{
                if correspondingDamages[i]=="LVL 0"{
                    correspondingDamages[i]="LVL 1"
                }
            }
        }
        
        var i=0
        var newMoves=[""]
        newMoves.remove(at: 0)
        
        for i in moves{
            print("\(i)")
            let sream = InputStream(fileAtPath: Bundle.main.path(forResource: "move_names", ofType: "csv")!)!
            var cv = try! CSVReader(stream: sream)
            while let row = cv.next() {
                if row[2] == "generation_id" {
                    continue
                }
                else if row[2] == "2"{
                    break
                }
                else if row[0]==i && row[1]=="9"{
                    newMoves.append(row[2])
                    break
                }
            }
        
        }
        moves=newMoves
        
    }
    
    @objc func tapDetected() {
        print("LOL U CLIKK ME")
        if(pokemon.GETnextEvo()=="-1"){
            
        }else{
            print("clicked \(pokemon.GETnextEvo())")
            var newPokemon=Pokemon(pokedexID:pokemon.GETnextEvo())
            newPokemon.getName()
            newPokemon.getRestOfData()
            pokemon=newPokemon
            self.viewDidLoad()
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tv.delegate=self
        tv.dataSource=self
        loadAMoves()
        mainView.isHidden=false
        pokemon.getRestOfData()
        name.text=pokemon.GETname().capitalized
        idLabel.text="\(pokemon.GETid())"
        picture.image=UIImage(named:"\(pokemon.GETid())")
        heightLBL.text=pokemon.GETheight()
        weightLBL.text=pokemon.GETweight()
        
        typeLBL.text=pokemon.GETtype()
        attackLBL.text=pokemon.GETattack()
        defenseLBL.text=pokemon.GETdefense()
        me.image=UIImage(named: pokemon.GETid())
        if pokemon.GETnextEvo()=="-1"{
            evoMe.image=nil
            evoMe.image=(UIImage(named: "no"))
        }else{
            evoMe.image=(UIImage(named: pokemon.GETnextEvo()))
        }
        evoLBL.text=getPokemonNameForID(id: pokemon.GETnextEvo())
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        singleTap.numberOfTapsRequired = 1
        
        evoMe.isUserInteractionEnabled = true
        evoMe.addGestureRecognizer(singleTap)
        
    }
    @IBAction func changeSelection(_ sender: Any) {
        if function.selectedSegmentIndex == 0{
            mainView.isHidden=false
            moveView.isHidden=true
        }
        else if function.selectedSegmentIndex == 1{
            mainView.isHidden=true
            moveView.isHidden=false
        }
    }
    func getPokemonNameForID(id:String)->String{
        var name:String="Next Evolution: "
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon", ofType: "csv")!)!
        let csv = try! CSVReader(stream: stream)
        while let row = csv.next() {
            if row[0]==id{
                name += "\(row[1].capitalized)"
            }
        }
        if name == "Next Evolution: "{
            name.append("None, Max Evolution")
        }
        return name
    }
    func getPokemonName(id:String)->String{
        var name:String=""
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon", ofType: "csv")!)!
        let csv = try! CSVReader(stream: stream)
        while let row = csv.next() {
            if row[0]==id{
                name += "\(row[1])"
            }
        }
        if name == ""{
            name.append("None, Max Evolution")
        }
        return name
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell=tableView.dequeueReusableCell(withIdentifier: "MoveCell", for: indexPath) as? MoveCell{
            cell.moveDamage.text = correspondingDamages[indexPath.row]
            cell.moveName.text=moves[indexPath.row]
            print("returning cell")
            return cell
        }
        else{
            print("not returning cell")
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("moves count is \(moves.count)")
        return moves.count
    }
}
