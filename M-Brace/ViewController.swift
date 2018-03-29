//
//  ViewController.swift
//  M-Brace
//
//  Created by Princess Macanlalay on 2/27/18.
//  Copyright © 2018 Princess Macanlalay. All rights reserved.
// Trying to commit to branch

import UIKit
import SwiftSocket
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var dataOutput: UILabel!
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var txtBox2: UITextField!
    @IBOutlet weak var lnChart: LineChartView!
    
    class SensorData {
        var numSensors : Int // number of sensors
        var data = [[Double]]() //store all numbers/imported set of numbers here
        var lnChartData = [[ChartDataEntry]]() //this is the array of points that will be displayed on graph
        var line : [IChartDataSet] = []
        let colorArray: [UIColor] = [.blue, .red, .magenta, .green, .brown, .orange]
        let labelArray: [String] = ["Line 1", "Line 2", "Line 3", "Line 4", "Line 5", "Line 6"]
        
        init(numSensors: Int) {
            self.numSensors = numSensors
            for _ in 0...self.numSensors {
                self.data.append([])
                self.lnChartData.append([])
            }
        }
        
        func updateSensorData(sensorNum: Int, dataVal: Double) {
            self.data[sensorNum].append(dataVal)
            if (self.data[sensorNum].count > 15) {
                self.data[sensorNum].removeFirst()
            }
            

            for i in 0..<self.data[0].count{
                let value = ChartDataEntry(x: Double(i), y: self.data[sensorNum][i])
                self.lnChartData[sensorNum].append(value)
            }
            line.append((LineChartDataSet(values: lnChartData[sensorNum], label: self.labelArray[sensorNum]))) // convert data points into a dataset
            line[sensorNum].setColor(colorArray[sensorNum])
            //return LineChartData(dataSets: line) //object will be added to chart
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        //updateGraph()
        testClass()
    }
    
    func testClass() {
        var output: [Double] = [1.2, 2.0]
        let dataValues: SensorData = SensorData(numSensors: 1)
        dataValues.updateSensorData(sensorNum: 0, dataVal: output[0])
        dataValues.updateSensorData(sensorNum: 1, dataVal: output[1])
        let data = LineChartData(dataSets: dataValues.line)
        lnChart.data = data
        lnChart.chartDescription?.text = "line graph"
    }
    
    func clientRequest() -> ([Double]) {
        var output = ""
        let client = TCPClient(address: "127.0.0.1", port: 12000)
        switch client.connect(timeout: 10){
        case .success:
            switch client.send(string: "hello world\n"){
            case .success:
                // timeout is necessary
                guard let data = client.read(1024*10, timeout: 2) else {
                    output = "Error: Failed to read data"
                    dataOutput.text = output
                    print(output)
                    return []
                }
                if let response = String(bytes: data, encoding: .utf8){
                    output = response
                    dataOutput.text = " "
                    print(output)
                    return response.components(separatedBy: " ").flatMap { Double($0) }
                }
            case .failure(_):
                output = "Error: failed to obtain response."
                dataOutput.text = output
                print(output)
            }
        case .failure(_):
            output = "Error: failed to connect."
            dataOutput.text = output
            print(output)
        }
        client.close()
        return []
    }
    
    func updateGraph() {
        var output : [Double] = clientRequest()
        if (output.count != 0) {
            let dataValues: SensorData = SensorData(numSensors: output.count)
            for i in 0..<dataValues.numSensors {
                dataValues.updateSensorData(sensorNum: i, dataVal: output[i])
            }
            let data = LineChartData(dataSets: dataValues.line)
            lnChart.data = data
            lnChart.chartDescription?.text = "line graph"
            while (true) {
                //output.removeAll()
                output = clientRequest()
                if (output.count == dataValues.numSensors) {
                    for i in 0..<dataValues.numSensors {
                        dataValues.updateSensorData(sensorNum: i, dataVal: output[i])
                    }
                    let data = LineChartData(dataSets: dataValues.line)
                    lnChart.data = data
                    lnChart.chartDescription?.text = "line graph"
                }
            }
        }
        return // Client failed first try
    }
    
/*    func updateGraph(value: SensorData){
        var lnChartData = [[ChartDataEntry]]() //this is the array of points that will be displayed on graph
        
        for _ in 0...value.numSensors {
            lnChartData.append([])
        }
        
        for i in 0..<numbers.data[0].count{
            let value = ChartDataEntry(x: Double(i), y: numbers.data[0][i])
            lnChartData[0].append(value)
            let value2 = ChartDataEntry(x: Double(i), y: numbers.data[1][i])
            lnChartData[1].append(value2)
            //lnChartData2 = lnChartData + lnChartData2
        }
//        let line1 = LineChartDataSet(values: lnChartData, label: "Numbers") //convert data points into a dataset
//        line1.colors = [NSUIColor.white]
//        let data = LineChartData() //object will be added to chart
//        data.addDataSet(line1)
//
        let line1 = LineChartDataSet(values: lnChartData[0], label: "Line1") //convert data points into a dataset
        line1.setColor(.blue)
        
        let line2 = LineChartDataSet(values: lnChartData[1], label: "Line2")
        line2.setColor(.red)
        
        let data = LineChartData(dataSets: [line1,line2]) //object will be added to chart
        //data.addDataSet(line1, line2)
        
        lnChart.data = data //adds the chart data to chart and graph updates
        lnChart.chartDescription?.text = "line graph"
    }*/
    
    
}

