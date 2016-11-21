//
//  TipoParser.swift
//  Instabook
//
//  Created by Leonardo Rania on 19/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation


public class TipoParser
{
    private var codice = "";
    private var descrizione = "";
    
    public TipoParser(var codice, var descrizione)
    {
        self.codice = codice;
        self.descrizione = descrizione;
    }
    
    public func getCodice() -> Any
    {
        return self.codice;
    }
    
    public func getDescrizione() -> Any
    {
        return self.codice;
    }
}