//
//  Pokemon.swift
//  Pokedex
//
//  Created by Gavin Craft on 6/18/18.
//  Copyright © 2018 Gavin Craft. All rights reserved.
//

import UIKit

class Pokemon {
    private var _name:String!
    private var _id:String!
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvoID:String!
    private var _speciesID:String!
    private var _baseXP:String!
    private var _typeID:[String]!
    
    func GETname() ->String {
        return _name!
    }
    func GETid() ->String {
        return _id!
    }
    func GETdescription() ->String {
        return _description!
    }
    func GETtype() ->String {
        return _type!
    }
    func GETdefense() ->String {
        return _defense!
    }
    func GETheight() ->String {
        return _height!
    }
    func GETweight() ->String {
        return _weight!
    }
    func GETattack() ->String {
        return _attack!
    }
    func GETnextEvo() ->String {
        if _nextEvoID == nil{
            return "-1"
        }
        else{
            return _nextEvoID!
        }
    }
    func GETspeciesID() ->String {
        return _speciesID!
    }
    func GETbaseXP() ->String {
        return _baseXP!
    }
    
    init(pokedexID:String) {
        self._id=pokedexID
        
        //get name
        
    }
    func setName(name:String){
        _name=name
    }
    func getRestOfData(){
        
        //add data for height, weight, base xp, and species id
        addData()
        
        //look up type
        lookUpType()
        
        //load evolution
        loadEvolution()
        
        //load attack and defense
        loadAttack_Defense()
    }
    private func loadAttack_Defense(){
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon_stats", ofType: "csv")!)!
        let csv = try! CSVReader(stream: stream)
        while let row = csv.next() {
            if row[0]==_id{
                if row[1]=="2"{
                    _attack=row[2]
                }else if row[1]=="3"{
                    _defense=row[2]
                }
            }
        }

    }
    private func lookUpTypeID(){
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon_types", ofType: "csv")!)!
        _typeID=[""]
        _typeID.remove(at: 0)
        let csv = try! CSVReader(stream: stream)
        while let row = csv.next() {
            if row[0]==_id{
                do{
                    print("notorious row1 is: \(row[1])")
                    _typeID.append(row[1])
                    print("\(row)")
                }
            }
        }
        print("typeid after lookupid is \(_typeID)")
    }
    private func addExtraMainData(height:String, weight:String, base_XP:String, speciesID:String){
        self._baseXP=base_XP
        self._height=height
        self._weight=weight
        self._speciesID=speciesID
            }
    private func addData(){
        let path=Bundle.main.path(forResource: "pokemon", ofType: "csv")
        do{
            let stream = InputStream(fileAtPath: path!)!
            let csv = try! CSVReader(stream: stream)
            var rows = [[String]]()
            while let row = csv.next() {
                rows.append(row)
            }
            
            for row in rows{
                
                var idd=row[0]
                if idd == "id"{
                    continue
                }
                else{
                    if row[0]==GETid(){
                        var speciesID=row[2]
                        print("in the addData function, my speciess id is \(speciesID)")
                        var height=row[3]
                        var weight=row[4]
                        var baseExp=row[5]
                        addExtraMainData(height: height, weight: weight, base_XP: baseExp, speciesID: speciesID)
                    }
                    //var id=idd
                    //var name=row[1]
                    
                    //                    var order=row[6]
                    //                    var def=row[7]
                    
                }
            }
        }
    }
    private func loadEvolution(){
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon_species", ofType: "csv")!)!
        let csv = try! CSVReader(stream: stream)
        var lol="-1"
        while let row = csv.next() {
            if row[3]==GETspeciesID(){
                lol=row[0]
                print("found evo for \(GETname()), it is \(lol)")
                break
            }
        }
        print("Evolved Species ID for \(GETname()) is \(lol). Species ID for self is \(GETspeciesID())")
        let sTream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon", ofType: "csv")!)!
        let cSv = try! CSVReader(stream: sTream)
        while let row = cSv.next() {
            if row[2]==lol{
                _nextEvoID=row[0]
                break
            }
        }
        _nextEvoID=lol
        print ("Evolved ID for \(GETname()) is \(GETnextEvo())")
    }
    private func lookUpType(){
        var types:[String]=[""]
        types.remove(at: 0)
        lookUpTypeID()
        for i in 0..._typeID.count-1{
            let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "type_names", ofType: "csv")!)!
            let csv = try! CSVReader(stream: stream)
            while let row = csv.next() {
                if row[0]==_typeID[i]{
                    if row[1]=="9"{
                        types.append(row[2])
                    }
                }
            }
        }
        var typeString=""
        for i in 0...types.count-1{
            if i==0{
                typeString+="\(types[i])"
            }
            else if i==types.count-1{
                typeString+=", and \(types[i])."
            }
            else{
                typeString+=", \(types[i])."
            }
        }
        _type=typeString
    }
    func getName(){
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "pokemon", ofType: "csv")!)!
        let csv = try! CSVReader(stream: stream)
        while let row = csv.next() {
            if row[0]=="id"{
                continue
            }else{
                if row[0]==GETid(){
                    _name=row[1]
                    break
                }
            }
        }
    }
}


