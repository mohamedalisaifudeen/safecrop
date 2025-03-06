from flask import Flask, jsonify,request
from flask_cors import CORS 

app=Flask(__name__)
CORS(app)

voltage_Dta={"Voltage":0}

@app.route("/voltage",methods=["POST"])
def voltage():
    data=request.get_json()
    if("voltage" in data):
        voltage_Dta["Voltage"]=data["voltage"]
        print("The voltage is",data["voltage"])
        return jsonify({"Messge":"Voltage updated sucssfully "})
    return jsonify({"Error":""})
    
@app.route("/getVoltage",methods=["GET"])
def voltageGet():
    return jsonify(voltage_Dta)


if(__name__ == '__main__'):
    app.run("0.0.0.0",port=5001,debug=True)