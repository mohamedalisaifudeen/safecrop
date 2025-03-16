from flask import Flask, request, jsonify

app = Flask(__name__)

# Store location data (In-memory for now, can upgrade to a DB)
location_data = {"latitude": None, "longitude": None}

# Route to receive location from Arduino (POST)
@app.route('/update-location', methods=['POST'])
def update_location():
    data = request.json
    location_data["latitude"] = data.get('latitude')
    location_data["longitude"] = data.get('longitude')
    return jsonify({"message": "Location updated successfully!"}), 200

# Route to send location to Flutter (GET)
@app.route('/get-location', methods=['GET'])
def get_location():
    return jsonify(location_data), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
  