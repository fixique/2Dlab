//
//  Matrix.swift
//  cg.Lab1
//
//  Created by Vlad Krupenko on 29.11.16.
//  Copyright © 2016 fixique. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript(index: Int) -> Character {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        return self[startIndex]
    }
    
    subscript(range: CountableRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: range.count)
        return self[startIndex..<endIndex]
    }
    
    subscript(range: CountableClosedRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: range.count)
        return self[startIndex...endIndex]
    }
    
    subscript(range: NSRange) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        return self[startIndex..<endIndex]
    }
}

class Matrix: NSObject  {
    
    internal var data:Array<Double>
    
    var rows: Int
    var columns: Int
    
    
    override var description: String {
        var d = ""
        
        for row in 0..<rows {
            for col in 0..<columns {
                
                let s = String(self[row,col])
                d += s + " "
                
            }
            d += "\n"
        }
        
        return d
    }

    init(_ data:Array<Double>, rows:Int, columns:Int) {
        self.data = data
        self.rows = rows
        self.columns = columns
    }
    
    init(rows:Int, columns:Int) {
        self.data = [Double](repeating: 0.0, count: rows*columns)
        self.rows = rows
        self.columns = columns
    }
    
    subscript(row: Int, col: Int) -> Double {
        get {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            return data[(row * columns) + col]
        }
        
        set {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            self.data[(row * columns) + col] = newValue
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Matrix {
        let m = Matrix(self.data, rows:self.rows, columns:self.columns)
        return m;
    }
    
    func row(index: Int) -> [Double] {
        var r = [Double]()
        for col in 0..<columns {
            r.append(self[index,col])
        }
        
        return r
    }
    
    func col(index: Int) -> [Double] {
        var c = [Double]()
        for row in 0..<rows {
            c.append(self[row,index])
        }
        
        return c
    }
    
    func clear() {
        self.data = [Double](repeating: 0.0, count: self.rows * self.columns)
        self.rows = 0
        self.columns = 0
    }
    
    func transfer(vector: Matrix) {
        
        precondition(vector.rows == 3 || vector.columns == 1, "Type vector is wrong!")
        
        let transferMatrix = Matrix([1,0,vector[0,0],0,1,vector[1,0],0,0,1],rows: 3, columns: 3)
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)

        for i in 0..<self.rows {
            let tempVector = transferMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data
    }
    
    func rotate(angle: Double, rotationDirection: Bool) {
        
        if (rotationDirection) {
            let rotationMatrix = Matrix([(cos(angle * M_PI / 180)),-sin(angle * M_PI / 180), 0, sin(angle * M_PI / 180) , cos(angle * M_PI / 180), 0, 0, 0, 1] ,rows: 3, columns: 3)
            let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
            
            for i in 0..<self.rows {
                let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
                for k in 0..<self.columns {
                    temp[i,k] = tempVector[k,0]
                }
            }
            
            self.data = temp.data

        } else {
            let rotationMatrix = Matrix([(cos(angle * M_PI / 180)),sin(angle * M_PI / 180), 0, -sin(angle * M_PI / 180) , cos(angle * M_PI / 180), 0, 0, 0, 1] ,rows: 3, columns: 3)
            let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
            
            for i in 0..<self.rows {
                let tempVector = rotationMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
                for k in 0..<self.columns {
                    temp[i,k] = tempVector[k,0]
                }
            }
            
            self.data = temp.data

        }
        
    }
    
    func scale(type: Int, scale: Double) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        var scaleMatrix = Matrix(rows: 3, columns: 3)
        
        switch type {
        case 0:
            scaleMatrix = Matrix([scale, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        case 1:
            scaleMatrix = Matrix([1, 0, 0, 0, scale, 0, 0, 0, 1] ,rows: 3, columns: 3)
        case 2:
            scaleMatrix = Matrix([scale, 0, 0, 0, scale, 0, 0, 0, 1] ,rows: 3, columns: 3)
        default:
            scaleMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        }
        
        for i in 0..<self.rows {
            let tempVector = scaleMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data
    }
    
    func reflect(type: Int) {
        let temp = Matrix(self.data, rows: self.rows, columns: self.columns)
        var reflectMatrix = Matrix(rows: 3, columns: 3)
        
        switch type {
        case 0:
            reflectMatrix = Matrix([1, 0, 0, 0, -1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        case 1:
            reflectMatrix = Matrix([-1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        case 2:
            reflectMatrix = Matrix([-1, 0, 0, 0, -1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        default:
            reflectMatrix = Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1] ,rows: 3, columns: 3)
        }
        
        for i in 0..<self.rows {
            let tempVector = reflectMatrix * Matrix(temp.row(index: i) ,rows: 3, columns: 1)
            for k in 0..<self.columns {
                temp[i,k] = tempVector[k,0]
            }
        }
        
        self.data = temp.data

    }
    
    
}







// Matrix Operations


func +(left: Matrix, right: Matrix) -> Matrix {
    
    precondition(left.rows == right.rows && left.columns == right.columns)
    
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        for col in 0..<left.columns {
            m[row,col] += right[row,col]
        }
    }
    
    return m
}

func -(left: Matrix, right: Matrix) -> Matrix {
    
    precondition(left.rows == right.rows && left.columns == right.columns)
    
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        for col in 0..<left.columns {
            m[row,col] -= right[row,col]
        }
    }
    
    return m
}

func *(left: Matrix, right: Double) -> Matrix {
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        for col in 0..<left.columns {
            m[row,col] *= right
        }
    }
    
    return m
}

func *(left: Double, right:Matrix) -> Matrix {
    let m = Matrix(right.data, rows: right.rows, columns: right.columns)
    
    for row in 0..<right.rows {
        for col in 0..<right.columns {
            m[row,col] *= left
        }
    }
    
    return m
}


func *(left: Matrix, right: Matrix) -> Matrix {
    
    var lcp = left.copy()
    var rcp = right.copy();
    
    if (lcp.rows == 1 && rcp.rows == 1) && (lcp.columns == rcp.columns) { // exception for single row matrices (inspired by numpy)
        rcp = rcp^
    }
    else if (lcp.columns == 1 && rcp.columns == 1) && (lcp.rows == rcp.rows) { // exception for single row matrices (inspired by numpy)
        lcp = lcp^
    }
    
    precondition(lcp.columns == rcp.rows, "Matrices cannot be multipied")
    
    let dot = Matrix(rows:lcp.rows, columns:rcp.columns)
    
    for rindex in 0..<lcp.rows {
        
        for cindex in 0..<rcp.columns {
            
            let a = lcp.row(index: rindex) ** rcp.col(index: cindex)
            dot[rindex,cindex] = a
        }
    }
    
    return dot

    
    
}

// transpose
postfix operator ^

postfix func ^(m:Matrix) -> Matrix {
    
    let transposed = Matrix(rows:m.columns, columns:m.rows)
    
    for row in 0..<m.rows {
        
        for col in 0..<m.columns {
            
            transposed[col,row] = m[row,col]
        }
        
        
    }
    return transposed
}

infix operator **

func **(left:[Double], right:[Double]) -> Double {
    
    
    var d : Double = 0
    for i in 0..<left.count {
        d += left[i] * right[i]
    }
    return d
}
