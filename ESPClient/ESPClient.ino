#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ESP8266HTTPClient.h>
//needed for library
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>         //https://github.com/tzapu/WiFiManager

const String thirdFloorPannelUrl = "http://192.168.41.99";
int sensorInput = 5;
int wifiSetupInput = 14;

void createPOSTRequest(String url, String params);
void bathroomOccupied(String url);
void bathroomUnoccupied(String url);



void setup() {
    pinMode(sensorInput, INPUT);
    pinMode(wifiSetupInput, INPUT);
    pinMode(LED_BUILTIN, OUTPUT);
    // put your setup code here, to run once:z
    Serial.begin(115200);

    //WiFiManager
    //Local intialization. Once its business is done, there is no need to keep it around
    WiFiManager wifiManager;

    if (digitalRead(wifiSetupInput)){
      Serial.println("Starting manual WiFi setup...");
      digitalWrite(LED_BUILTIN, LOW);
      wifiManager.resetSettings();
      wifiManager.setAPStaticIPConfig(IPAddress(10,0,1,1), IPAddress(10,0,1,1), IPAddress(255,255,255,0));
      wifiManager.setSaveConfigCallback(saveConfigCallback);
      wifiManager.startConfigPortal("Bathroom stall third floor");
    }
    else{
    wifiManager.setAPStaticIPConfig(IPAddress(10,0,1,1), IPAddress(10,0,1,1), IPAddress(255,255,255,0));

    //fetches ssid and pass from eeprom and tries to connect
    //if it does not connect it starts an access point with the specified name
    //here  "AutoConnectAP"
    //and goes into a blocking loop awaiting configuration
    wifiManager.autoConnect("Bathroom stall third floor");
    //or use this for auto generated name ESP + ChipID
    //wifiManager.autoConnect();

    
    //if you get here you have connected to the WiFi
    Serial.println("connected...yeey :)");
    }
}

void loop() {

  Serial.println("sensor = " + String(digitalRead(sensorInput)));
  
 if(WiFi.status()== WL_CONNECTED){   //Check WiFi connection status
  if (digitalRead(sensorInput)){
      bathroomOccupied(thirdFloorPannelUrl+"/led");
    } else{
      bathroomUnoccupied(thirdFloorPannelUrl+"/led");
  }
 }else{
    Serial.println("Error in WiFi connection");   
 }
  ESP.deepSleep(0);
}  

void createPOSTRequest(String url, String params){
  HTTPClient http;
  http.begin(url);      
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
 
  int httpCode = http.POST(params);  
  String payload = http.getString();                 
  
  Serial.println(httpCode);   
  Serial.println(payload);
  http.end(); 
}

void bathroomOccupied(String url){
    createPOSTRequest(url, "state=occupied");
}

void bathroomUnoccupied(String url){
    createPOSTRequest(url, "state=unoccupied");
}

void saveConfigCallback(){
    while(true){
        digitalWrite(LED_BUILTIN, LOW);
        delay(125);
        digitalWrite(LED_BUILTIN, HIGH);
        delay(125);
        digitalWrite(LED_BUILTIN, LOW);
        delay(125);
        digitalWrite(LED_BUILTIN, HIGH);
        delay(125);
        delay(500);
    }  
}
