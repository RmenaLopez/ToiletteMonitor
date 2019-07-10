#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino

//needed for library
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include "WiFiManager.h"         //https://github.com/tzapu/WiFiManager

std::unique_ptr<ESP8266WebServer> server;

//default custom static IP
char server_static_ip[16] = "192.168.45.99";
char server_static_gw[16] = "192.168.44.1";
char server_static_sn[16] = "255.255.254.0";
char server_static_dns[16] = "8.8.8.8";

//default custom static IP for access point
char mgnt_static_ip[16] = "10.0.1.1";
char mgnt_static_gw[16] = "10.0.1.1";
char mgnt_static_sn[16] = "255.255.255.0";


const int LedPin = 2;

void handleRoot() {
  server->send(200, "text/plain", "hello from esp8266!");
}

void handleToggleLED(){
  String bathroomStallState = server->arg("state");
  server->send(200, "text/plain", "LED STATE ARGUMENT: " + bathroomStallState);
  if ( bathroomStallState == "occupied"){
    digitalWrite(LedPin, LOW);
    }
    else{
      digitalWrite(LedPin,HIGH);  
    }
}

void handleNotFound() {
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server->uri();
  message += "\nMethod: ";
  message += (server->method() == HTTP_GET) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server->args();
  message += "\n";
  for (uint8_t i = 0; i < server->args(); i++) {
    message += " " + server->argName(i) + ": " + server->arg(i) + "\n";
  }
  server->send(404, "text/plain", message);
}

void setup() {
  pinMode(LedPin, OUTPUT);
  digitalWrite(LedPin, LOW);
  // put your setup code here, to run once:
  Serial.begin(115200);
  //Serial.setDebugOutput(true);
  //WiFiManager
  //Local intialization. Once its business is done, there is no need to keep it around
  WiFiManager wifiManager;
  //reset saved settings
  //wifiManager.resetSettings();
  wifiManager.setAPStaticIPConfig(IPAddress(10,0,1,1), IPAddress(10,0,1,1), IPAddress(255,255,255,0));
  //fetches ssid and pass from eeprom and tries to connect
  //if it does not connect it starts an access point with the specified name
  //here  "AutoConnectAP"
  //and goes into a blocking loop awaiting configuration
  //wifiManager.autoConnect("AutoConnectAP");
  //or use this for auto generated name ESP + ChipID

  IPAddress server_ip, server_gw, server_sn, server_dns;
  server_ip.fromString(server_static_ip);
  server_gw.fromString(server_static_gw);
  server_sn.fromString(server_static_sn);
  server_dns.fromString(server_static_dns);

  IPAddress mgnt_ip, mgnt_gw, mgnt_sn;
  mgnt_ip.fromString(mgnt_static_ip);
  mgnt_gw.fromString(mgnt_static_gw);
  mgnt_sn.fromString(mgnt_static_sn);

  wifiManager.setAPStaticIPConfig(mgnt_ip, mgnt_gw, mgnt_sn);
  //wifiManager.setSTAStaticIPConfig(server_ip, server_gw,  server_sn, server_dns);
  
  if (!wifiManager.autoConnect("AutoConnectAP")) {
    Serial.println("failed to connect, we should reset as see if it connects");
    delay(3000);
    ESP.reset();
    delay(5000);
  }

  
  //if you get here you have connected to the WiFi
  Serial.println("connected...yeey :)");
  
  //WiFi.config(_ip, _dns, _gw);
  server.reset(new ESP8266WebServer(WiFi.localIP(), 80));

  server->on("/", handleRoot);
  server->on("/led", handleToggleLED);

  server->on("/inline", []() {
    server->send(200, "text/plain", "this works as well");
  });

  server->onNotFound(handleNotFound);

  server->begin();
  Serial.println("HTTP server started");
  Serial.println(WiFi.localIP());

  Serial.println(""); 
}

void loop() {
  // put your main code here, to run repeatedly:
  server->handleClient();
}
