import firebase_admin
from firebase_admin import credentials, messaging, firestore
from flask import Flask, request, jsonify


app = Flask(__name__)


cred = credentials.Certificate("firebase_service_key.json")
 
firebase_admin.initialize_app(cred)


db = firestore.client()

# FCM token 
FCM_TOKEN = "e7XgvWuGT0Ct_qwa9u-LFG:APA91bF7SEju9zZiKpPAUh4fbfydBC4FaWnlYvRdvsmUwQ2OLyIIdUbXhjQJfRW6zMr97rSqmADHSolEYQsYLncbQqodFS9hiHcF3J_im4eg3T3OFDTv6LE"

# Route to handle IoT messages (when a voltage drop is detected)
@app.route("/iot/message", methods=["POST"])
def handle_iot_message():
    # Get the data from the incoming HTTP POST request
    data = request.json

    # Check for 'voltage_drop' key in the incoming data
    voltage_drop_detected = data.get("voltage_drop", False)

    if voltage_drop_detected:
        # If a voltage drop is detected, store the notification in Firestore
        store_notification_in_firestore("Alert!", "Elephant came to the paddy field")

        # Send an FCM notification to the Flutter app
        send_fcm_notification()

    # Return success response
    return jsonify({"status": "success", "message": "Notification sent"})


# Function to send FCM notification
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
def store_notification_in_firestore(title, body):
    notifications_ref = db.collection('notifications')  # Reference to the notifications collection
    notifications_ref.add({
        'title': title,
        'body': body,
        'timestamp': firestore.SERVER_TIMESTAMP  # Automatically set the current timestamp
    })
    print(f"Notification stored in Firestore: {title}")

if __name__ == "__main__":
    # Run the Flask app on the specified host and port
    app.run(debug=True, host="0.0.0.0", port=5000)
