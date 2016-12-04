//
//  ViewController.swift
//  cg.Lab1
//
//  Created by Vlad Krupenko on 29.11.16.
//  Copyright © 2016 fixique. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var coordField: UITextField!
    @IBOutlet weak var relationsfield: UITextField!

    
    
    let zeroCordX: Double = 512
    let zeroCordY: Double = 345
    let u: Double = 1.0
    //var vertex = Matrix([0, 0, 0 , 100, 100, 100, 100, 0], rows: 4, columns: 2)
    //let relations = Matrix([0,1,1,2,2,3,3,0], rows: 4, columns: 2)
    var vertex: Matrix = Matrix([0, 0, 0 , 100, 100, 100, 100, 0], rows: 4, columns: 2)
    var relations: Matrix = Matrix([0,1,1,2,2,3,3,0], rows: 4, columns: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func setFigure(_ sender: AnyObject) {
        let dataVertex = convertFromStringFeild(text: coordField.text!)
        let dataRelations = convertFromStringFeild(text: relationsfield.text!)
        
        print(dataVertex)
        print(dataRelations)
        
        
        vertex = Matrix(dataVertex, rows: dataVertex.count / 2, columns: 2)
        relations = Matrix(dataRelations, rows: dataRelations.count / 2, columns: 2)
        
        vertex = convertCoord(points: vertex)
        
        drawFigure(points: vertex, relations: relations)
        print("\(vertex)")
        
    }
    
    
    @IBAction func transferUp(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([0,10,1], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func transferDown(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([0,-10,1], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func transferRight(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([10,0,1], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    @IBAction func transferLeft(_ sender: AnyObject) {
        vertex.transfer(vector: Matrix([-10,0,1], rows: 3, columns: 1))
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func rotationBack(_ sender: AnyObject) {
        vertex.rotate(angle: 1, rotationDirection: true)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func rotationForward(_ sender: AnyObject) {
        vertex.rotate(angle: 1, rotationDirection: false)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func scaleXPlus(_ sender: AnyObject) {
        vertex.scale(type: 0, scale: 1.25)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func scaleXMin(_ sender: AnyObject) {
        vertex.scale(type: 0, scale: 0.75)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func scaleYPlus(_ sender: AnyObject) {
        vertex.scale(type: 1, scale: 1.25)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func scaleYMin(_ sender: AnyObject) {
        vertex.scale(type: 1, scale: 0.75)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func scaleXYPlus(_ sender: AnyObject) {
        vertex.scale(type: 2, scale: 1.25)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func scaleXYMin(_ sender: AnyObject) {
        vertex.scale(type: 2, scale: 0.75)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func reflectX(_ sender: AnyObject) {
        vertex.reflect(type: 0)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func reflectY(_ sender: AnyObject) {
        vertex.reflect(type: 1)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    @IBAction func reflectZero(_ sender: AnyObject) {
        vertex.reflect(type: 2)
        print("\(vertex)")
        drawFigure(points: vertex, relations: relations)
    }
    
    func drawFigure(points: Matrix, relations: Matrix) {
        
        let decPoints = convertToDec(points: points)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1024, height: 691), false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(3.0)
        context.setFillColor(UIColor.purple.cgColor)
        context.setStrokeColor(UIColor.purple.cgColor)
        
        for i in 0..<relations.rows {
            for k in 0..<decPoints.columns-1 {
                context.move(to: CGPoint(x: (decPoints[Int(relations[i,0]),k] + zeroCordX), y: zeroCordY - (decPoints[Int(relations[i,0]),k+1] )))
                context.addLine(to: CGPoint(x: (decPoints[Int(relations[i,1]),k] + zeroCordX), y: zeroCordY - (decPoints[Int(relations[i,1]),k+1])))
            }
        }
        context.drawPath(using: .fillStroke)
        context.setFillColor(UIColor.black.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        
        context.setFillColor(UIColor.black.cgColor)
        context.move(to: CGPoint(x: 512, y: 0))
        context.addLine(to: CGPoint(x: 512, y: 343))
        context.move(to: CGPoint(x: 512, y: 346))
        context.addLine(to: CGPoint(x: 512, y: 691))
        context.move(to: CGPoint(x: 0, y: 345))
        context.addLine(to: CGPoint(x: 1366, y: 345))
        context.drawPath(using: .fillStroke)
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext() // Получившийся рисунок присваеваем константе
        UIGraphicsEndImageContext() // Заканчиваем функцию отрисовки
        
        imageView.image = img
    }
    
    
    
    func convertFromStringFeild(text: String) -> [Double]{
        
        var data = [Double]()
        var tempStr: String = ""
        
        for i in 0..<text.characters.count {
            if text[i] != "," && text[i] != " " {
                tempStr = tempStr + String(text[i])
                if i == text.characters.count - 1 {
                    data.append(Double(tempStr)!)
                }
            } else {
                if tempStr != "" {
                    data.append(Double(tempStr)!)
                }
                tempStr = ""
            }
        }
        
        return data
    }
    
    func convertCoord(points: Matrix) -> Matrix {
        
        let resultM = Matrix(rows: points.rows, columns: 3)
        
        for i in 0..<points.rows {
            for k in 0..<points.columns {
                resultM[i,k] = points[i,k] * u
            }
        }
        
        for i in 0..<points.rows {
            resultM[i,2] = u;
        }
        
        return resultM
        
    }
    
    func convertToDec(points: Matrix) -> Matrix {
        
        let resultM = Matrix(rows: points.rows, columns: 2)
        
        for i in 0..<points.rows {
            for k in 0..<points.columns-1 {
                resultM[i,k] = points[i,k] / u
            }
        }
        
        return resultM
    }
       
}

