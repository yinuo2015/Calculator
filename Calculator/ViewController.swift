//
//  ViewController.swift
//  Calculator
//
//  Created by 胡强 on 2/2/15.
//  Copyright (c) 2015 胡强. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var display: UILabel!
	@IBOutlet weak var history: UILabel!
	/// 用于判断每个数字是否输入完毕
	var userIsInTheMiddleOfTypingANumber = false
	
	@IBAction func appendHistory(sender: UIButton) {
		let digit = sender.currentTitle!
		if (digit == "." && display.text!.rangeOfString(".") != nil){
			return
		}
		history.text = history.text! + digit
	}
	
	
	/**
	点击数字按钮时调用
	
	:param: sender 点击的数字按钮
	*/
	@IBAction func appendDigit(sender: UIButton) {
		
		let digit = sender.currentTitle!
		
		if userIsInTheMiddleOfTypingANumber {
			if (digit == "." && display.text!.rangeOfString(".") != nil){
				return
			}
			display.text = display.text! + digit
		} else {
			if (digit == "."){
				display.text = "0."
			} else {
				display.text = digit
			}
			userIsInTheMiddleOfTypingANumber = true
		}
	}
	
	//改变数字符号
	@IBAction func changeSign(sender: UIButton) {
		if userIsInTheMiddleOfTypingANumber{
			displayValue = -displayValue
			userIsInTheMiddleOfTypingANumber = true
		} else {
			performOperation{-1 * $0}
		}
	}
	//退格键
	@IBAction func backSpace(sender: UIButton) {
		if countElements(display.text!) <= 1 {
			display.text = "0"
			userIsInTheMiddleOfTypingANumber = false
			return
		}
		display.text = dropLast(display.text!)
		userIsInTheMiddleOfTypingANumber = true
	}
	/**
	计算结果的方法,点击运算符时调用
	:param: sender 所点击的按钮
	*/
	@IBAction func operate(sender: UIButton) {
		let operation = sender.currentTitle!
		if userIsInTheMiddleOfTypingANumber {
			enter()
			if operation == "π"{
				performOperation{M_PI*$0}
			}
		} else if operation == "π" {
			display.text = "π"
		}
		
		switch operation {
		case "✖️" : performOperation {$0 * $1}
		case "➗" : performOperation {$1 / $0}
		case "➕" : performOperation {$0 + $1}
		case "➖" : performOperation {$1 - $0}
		case "√" :
			if (operandStack.last < 0){  //判断数字数否为负数
				return
			}
			performOperation { sqrt($0)}
		case "sin" : performOperation{ sin($0)}
		case "cos" : performOperation{ cos($0)}
		case "C" :
			display.text = "0"
			history.text = ""
			operandStack.removeAll(keepCapacity: false)
			println("operandStack = \(operandStack)")
		default:break
		}
		
	}
	/**
	两个参数计算
	*/
	func performOperation (operation:(Double,Double)->Double ){
		if operandStack.count >= 2{
			displayValue = operation (operandStack.removeLast(),operandStack.removeLast())
			enter()
		}
	}
	/**
	一个参数计算
	*/
	func performOperation (operation:(Double)->Double ){
		if operandStack.count >= 1{
			displayValue = operation (operandStack.removeLast())
			enter()
		}
	}
	
	/// 用于计算的数组
	var operandStack = Array<Double>()
	/**
	点击enter键调用
	将数据加入数组
	*/
	@IBAction func enter() {
		userIsInTheMiddleOfTypingANumber = false
		operandStack.append(displayValue)
		println("operandStack = \(operandStack)")
	}
	/// 显示的数据
	var displayValue : Double {
		get {
			if display.text! == "π"{
				return M_PI
			} else {
				return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
			}
		}
		set {
			display.text = "\(newValue)"
			userIsInTheMiddleOfTypingANumber = false
		}
	}
}

