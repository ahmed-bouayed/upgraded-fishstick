---
title: mosquitto
description: description
published: false
date: 2025-01-01
categories: 
tags: 
image:
  path: /assets/img/headers/image.webp
  lqip: data:image/webp;base64,
  alt: image
---


📦 Architecture Overview
```css
[Android App]
    ⬇ subscribes
[MQTT Broker on your VPS] <-- receives notification
    ⬆ publishes
[FastAPI Backend / script] → publishes message to topic
```



🛠️ Step-by-Step Implementation
✅ 1. Install MQTT Broker (e.g., Mosquitto) on VPS
Install with Docker:

bash
Copy
Edit
docker run -d --name mosquitto \
  -p 1883:1883 -p 9001:9001 \
  -- restart always \
  eclipse-mosquitto

Now your broker is ready at mqtt://your-vps-ip:1883.

✅ 2. Android App: Integrate MQTT Client
Use the Paho MQTT client in your build.gradle:

```gradle
implementation 'org.eclipse.paho:org.eclipse.paho.client.mqttv3:1.2.5'
implementation 'org.eclipse.paho:org.eclipse.paho.android.service:1.1.1'
```
✅ 3. Subscribe to a Topic in Your App (Kotlin)
```kotlin
val clientId = MqttClient.generateClientId()
val client = MqttAndroidClient(context, "tcp://your-vps-ip:1883", clientId)

val options = MqttConnectOptions()
options.isCleanSession = true

client.connect(options, null, object : IMqttActionListener {
    override fun onSuccess(asyncActionToken: IMqttToken?) {
        Log.d("MQTT", "Connected")
        client.subscribe("ahmed-notifs", 1)
    }

    override fun onFailure(asyncActionToken: IMqttToken?, exception: Throwable?) {
        Log.e("MQTT", "Connection failed", exception)
    }
})

client.setCallback(object : MqttCallback {
    override fun messageArrived(topic: String?, message: MqttMessage?) {
        val notifMsg = message.toString()
        showNotification("New Alert", notifMsg)
    }

    override fun connectionLost(cause: Throwable?) {}
    override fun deliveryComplete(token: IMqttDeliveryToken?) {}
})
```
✅ 4. Show Notification (Kotlin)
```kotlin
fun showNotification(title: String, message: String) {
    val builder = NotificationCompat.Builder(this, "default")
        .setSmallIcon(R.drawable.ic_notification)
        .setContentTitle(title)
        .setContentText(message)
        .setPriority(NotificationCompat.PRIORITY_HIGH)

    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    notificationManager.notify(1, builder.build())
}
```
You’ll also need to create a notification channel (for Android 8+).

✅ 5. Send Notification from Backend (FastAPI)
```python
import paho.mqtt.publish as publish

publish.single("ahmed-notifs", "Hello from backend!", hostname="your-vps-ip")
```
You can also send from CLI:
```bash
mosquitto_pub -h your-vps-ip -t ahmed-notifs -m "Backend message"
```
🔐 Optional: Secure It
- Enable authentication in mosquitto.conf
- Use TLS/SSL (I can guide you with certs)
- Assign per-user topics like user_1234_alerts
