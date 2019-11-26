import controlP5.*;
import mqtt.*;
import processing.serial.*;

Serial port;
MQTTClient client;
ControlP5 cp5;

Hand[] hands = new Hand[12];

int min = 1000;
int max = 0;
int[] samples;
int sampleStart = 0;
int lf = 10; // ASCII linefeed

void setup(){
  size(600, 600);
  cp5 = new ControlP5(this);
  cp5.addScrollableList("portSelect")
     .addItems(Serial.list());
  cp5.getProperties().addSet("ignored");
  cp5.getProperties().move(cp5.getController("portSelect"), "default", "ignored");
  float step = height / hands.length;
  for(int i = 0; i < hands.length; i++){
    hands[i] = new Hand((int)(i * step), (int)step, cp5);
  }
  cp5.loadProperties("prop.json");
  client = new MQTTClient(this);
  client.connect("mqtt://localhost:1883", "hands");
  samples = new int[width];
}

public void portSelect(int n){
  port = new Serial(this, Serial.list()[n], 9600);
  port.bufferUntil('\n');
}

void draw(){
  for(Hand hand : hands){
    hand.draw();
  }
  /*
  background(255);
  int prevY = samples[sampleStart];
  for(int i = (sampleStart + 1) % samples.length, x = 1; 
      i != sampleStart; 
      i = (i + 1) % samples.length, x++){
    line(x-1, map(prevY, min, max, height, 0), x, map(samples[i], min, max, height, 0));
    prevY = samples[i];
  }
  */
}

void keyPressed(){
  switch(key){
    case 'r':
    case 'R':
      min = 1000;
      max = 0;
      break;
    case 's':
    case 'S':
    cp5.saveProperties("prop.json", "default");
    break;
    case 'l':
    case 'L':
    cp5.loadProperties("prop.json");
    break;
    case 'b':
    case 'B':
    for(Hand hand : hands){
      hand.broadcast();
    }
    break;
  }
}

void serialEvent(Serial p){
  String in = p.readString();
  String[] parts = split(in, '\t');
  if (parts.length == 3){
    try{
    int sensor = Integer.parseInt(parts[0].trim());
    int base = Integer.parseInt(parts[1].trim());
    int value = Integer.parseInt(parts[2].trim());
    
    if (sensor < hands.length && sensor >= 0){
      hands[sensor].addSample(base, value);
    }
    
    } catch(Exception e){
      println("err: ");
      println(e);
    }
  }
}

void clientConnected() {
  println("client connected");

  client.subscribe("/hello");
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
}

void connectionLost() {
  println("connection lost");
}
