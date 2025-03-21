from flask import Flask, request, jsonify  

app = Flask(__name__)  

# Store the system status
system_status = {"status": "inactive"}

@app.route('/update_status', methods=['POST'])  # Define an endpoint to update system status
def update_status():
    global system_status  
    data = request.json  
    status = data.get("status")  
    # Verify that the status is either 0 or 1.
    if status in [0, 1]:
        system_status["status"] = "active" if status == 1 else "inactive"  # Update system status based on value
        return jsonify({"message": "Status updated", "status": system_status["status"]})  
    else:
        return jsonify({"error": "Invalid status value, must be 0 or 1"}), 400  

@app.route('/get_status', methods=['GET'])  # Define an endpoint to get the current system status
def get_status():
    return jsonify(system_status)  

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)  
