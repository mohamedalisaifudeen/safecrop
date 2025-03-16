from flask import Flask, request, jsonify

app = Flask(__name__)

# Store the system status (default is inactive)
system_status = {"status": "inactive"}

@app.route('/update_status', methods=['POST'])
def update_status():
    global system_status
    data = request.json
    status = data.get("status")

    # Ensure status is either 1 or 0
    if status in [0, 1]:
        system_status["status"] = "active" if status == 1 else "inactive"
        return jsonify({"message": "Status updated", "status": system_status["status"]})
    else:
        return jsonify({"error": "Invalid status value, must be 0 or 1"}), 400

@app.route('/get_status', methods=['GET'])
def get_status():
    return jsonify(system_status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
