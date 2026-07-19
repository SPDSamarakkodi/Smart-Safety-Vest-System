#include "secrets.h"
#include <Firebase.h>
Firebase fb(REFERENCE_URL);


void setup() {
    Serial.begin(115200);
    
    // Board-specific initialization
    #if !defined(ESP8266)
        WiFi.mode(WIFI_STA);
    #else
        pinMode(LED_BUILTIN, OUTPUT);
        digitalWrite(LED_BUILTIN, LOW);
    #endif
    
    WiFi.disconnect();
    delay(1000);

    /* Connect to WiFi */
    Serial.println();
    Serial.println();
    Serial.print("Connecting to: ");
    Serial.println(WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    while (WiFi.status() != WL_CONNECTED) {
        Serial.print("-");
        delay(500);
    }

    Serial.println();
    Serial.println("WiFi Connected");
    Serial.println();

    // Turn on built-in LED for UNO R4 WiFi
    #if defined(ESP8266)
        digitalWrite(LED_BUILTIN, HIGH);
    #endif
    
    Serial.println("Setting data in Firebase...");
    
    
    int responseCode;
    
    responseCode = fb.setString("Example/myString", "Hello World!");
    Serial.print("Set String - Response Code: ");
    Serial.println(responseCode);
    
    responseCode = fb.setInt("Example/myInt", 123);
    Serial.print("Set Int - Response Code: ");
    Serial.println(responseCode);
    
    responseCode = fb.setFloat("Example/myFloat", 45.67);
    Serial.print("Set Float - Response Code: ");
    Serial.println(responseCode);
    
    responseCode = fb.setBool("Example/myBool", true);
    Serial.print("Set Bool - Response Code: ");
    Serial.println(responseCode);

    Serial.println();

    
    Serial.println("Pushing data to Firebase...");
    
    responseCode = fb.pushString("Push", "Foo-Bar");
    Serial.print("Push String - Response Code: ");
    Serial.println(responseCode);
    
    responseCode = fb.pushInt("Push", 890);
    Serial.print("Push Int - Response Code: ");
    Serial.println(responseCode);
    
    responseCode = fb.pushFloat("Push", 12.34);
    Serial.print("Push Float - Response Code: ");
    Serial.println(responseCode);
    
    responseCode = fb.pushBool("Push", false);
    Serial.print("Push Bool - Response Code: ");
    Serial.println(responseCode);

    Serial.println();
    
    Serial.println("Getting data from Firebase...");
   
    String retrievedString;
    responseCode = fb.getString("Example/myString", retrievedString);
    Serial.print("Get String - Response Code: ");
    Serial.println(responseCode);
    Serial.print("Retrieved String: ");
    Serial.println(retrievedString);
    
    int retrievedInt;
    responseCode = fb.getInt("Example/myInt", retrievedInt);
    Serial.print("Get Int - Response Code: ");
    Serial.println(responseCode);
    Serial.print("Retrieved Int: ");
    Serial.println(retrievedInt);
    
    float retrievedFloat;
    responseCode = fb.getFloat("Example/myFloat", retrievedFloat);
    Serial.print("Get Float - Response Code: ");
    Serial.println(responseCode);
    Serial.print("Retrieved Float: ");
    Serial.println(retrievedFloat);
    
    bool retrievedBool;
    responseCode = fb.getBool("Example/myBool", retrievedBool);
    Serial.print("Get Bool - Response Code: ");
    Serial.println(responseCode);
    Serial.print("Retrieved Bool: ");
    Serial.println(retrievedBool);

    Serial.println();

    /* ===== REMOVING DATA FROM FIREBASE ===== */
    
    Serial.println("Removing data from Firebase...");
    
    
    responseCode = fb.remove("Example");
    Serial.print("Remove Example - Response Code: ");
    Serial.println(responseCode);
    
    responseCode = fb.remove("Push");
    Serial.print("Remove Push - Response Code: ");
    Serial.println(responseCode);

    Serial.println();
    Serial.println("Example completed!");
}

void loop() {

}
