from flask import Flask, jsonify,request
import firebase_admin
from firebase_admin import credentials, messaging, firestore
from flask_cors import CORS 
import os
from dotenv import load_dotenv

app=Flask(__name__)
CORS(app)

cred = credentials.Certificate("firebase_service_key.json")
 
firebase_admin.initialize_app(cred)


db = firestore.client()

load_dotenv()
# Store credentials
FCM_TOKEN= os.getenv('FCM_TOKEN')

print(FCM_TOKEN)

sample_use_id="Je2jJZ5aTcYegufVwe9nuKKsqKr2"

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


@app.route("/iot/message", methods=["POST"])
def handle_iot_message():
    # Get the data from the incoming HTTP POST request
    data = request.json
    sample_use_id=data["UUID"]

    # Check for 'voltage_drop' key in the incoming data
    voltage_drop_detected = data.get("voltage_drop", False)

    if voltage_drop_detected:
        # If a voltage drop is detected, store the notification in Firestore
        store_notification_in_firestore("Alert!", "Elephant came to the paddy field",sample_use_id)

        # Send an FCM notification to the Flutter app
        send_fcm_notification()

    # Return success response
    return jsonify({"status": "success", "message": "Notification sent"})

def send_fcm_notification():
    # Define the message payload
    message = messaging.Message(
        notification=messaging.Notification(
            title="Alert",
            body="Elephant came to the paddy field!",
        ),
        token=FCM_TOKEN,  # The device token to send the notification to
    )

    try:
        # Send the FCM notification
        response = messaging.send(message)
        print(f"Successfully sent message: {response}")
    except Exception as e:
        print(f"Error sending message: {e}")


# Function to store the notification in Firestore
def store_notification_in_firestore(title, body,sample_use_id):
    notifications_ref = db.collection('notifications')  # Reference to the notifications collection
    notifications_ref.add({
        'title': title,
        'body': body,
        'UUID':sample_use_id,
        'timestamp': firestore.SERVER_TIMESTAMP  # Automatically set the current timestamp
    })
    print(f"Notification stored in Firestore: {title}")

if(__name__ == '__main__'):
    app.run("0.0.0.0",port=5001,debug=True)