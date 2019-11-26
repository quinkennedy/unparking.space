import controlP5.*;
import mqtt.*;
import processing.serial.*;
import java.util.*;

ControlP5 cp5;
Serial serial;
OPC opc;
MQTTClient client;

Hand[] hands;
Words words;
Ambient ambient;

ColorWheel handBaseColor;
ColorWheel handTouchColor;

void setup(){
  size(500, 660);
  initCP5();
  initOPC();
  cp5.loadProperties(("prop.json"));
  ambient.c.setRGB((int)ambient.c.getValue());
  words.c.setRGB((int)words.c.getValue());
  handBaseColor.setRGB((int)handBaseColor.getValue());
  handTouchColor.setRGB((int)handTouchColor.getValue());
  client = new MQTTClient(this);
  client.connect("mqtt://localhost:1883", "brain");
}

void draw(){
  background(100);
  for(Hand hand : hands){
    hand.draw();
  }
  words.draw();
  ambient.draw();
}

void handleTouch(char c){
  switch(c){
    case '0':
    hands[0].touched();
    break;
    case '1':
    hands[1].touched();
    break;
    case '2':
    hands[2].touched();
    break;
    case '3':
    hands[3].touched();
    break;
    case '4':
    hands[4].touched();
    break;
    case '5':
    hands[5].touched();
    break;
    case '6':
    hands[6].touched();
    break;
  }
}

void handleRelease(char c){
  switch(c){
    case '0':
    hands[0].released();
    break;
    case '1':
    hands[1].released();
    break;
    case '2':
    hands[2].released();
    break;
    case '3':
    hands[3].released();
    break;
    case '4':
    hands[4].released();
    break;
    case '5':
    hands[5].released();
    break;
    case '6':
    hands[6].released();
    break;
  }
}

void serialEvent(Serial port){
  String in = port.readString();
  print("got " + in);
  String[] pieces = in.trim().split(" ");
  print(" " + pieces.length);
  if (pieces.length == 2){
    print(":"+pieces[0]+","+pieces[1]+":");
    switch(pieces[1]){
      case "touched":
      handleTouch(pieces[0].charAt(0));
      break;
      case "released":
      handleRelease(pieces[0].charAt(0));
      break;
      default:
      print(" didn't match");
      break;
    }
  }
  println();
}

void keyPressed() {
  switch(key){
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    handleTouch(key);
    break;
    case '8':
    hands[0].touched();
    hands[1].touched();
    hands[2].touched();
    hands[3].touched();
    hands[4].touched();
    hands[5].touched();
    hands[6].touched();
    break;
    case 's':
    case 'S':
    cp5.saveProperties("prop.json", "default");
    break;
    case 'l':
    case 'L':
    cp5.loadProperties("prop.json");
    break;
  }
}

void keyReleased(){
  switch(key){
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    handleRelease(key);
    break;
    case '8':
    hands[0].released();
    hands[1].released();
    hands[2].released();
    hands[3].released();
    hands[4].released();
    hands[5].released();
    hands[6].released();
    break;
  }
}

void initOPC(){
  opc = new OPC(this, "localhost", 7890);
  hands = new Hand[]{
    new Hand( 0, 440, 64*1),
    new Hand(6, 440, 64*1+6),
    new Hand(),
    new Hand(),
    new Hand(),
    new Hand(12, 440, 64*3),
    new Hand(18, 440, 64*3+6)
  };
  handBaseColor = cp5.addColorWheel("base")
    .setPosition(50, 440)
    .registerProperty("value")
    .removeProperty("ArrayValue");
  handTouchColor = cp5.addColorWheel("touch")
    .setPosition(260, 440)
    .registerProperty("value")
    .removeProperty("ArrayValue");
  words = new Words(0, 0);
  ambient = new Ambient(0, 220);
}

void clientConnected() {
  println("client connected");

  client.subscribe("hand/+");
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
  String[] parts = topic.split("/");
  try{
    boolean touched = Boolean.parseBoolean(new String(payload));
    if (touched){
      handleTouch(parts[1].charAt(0));
    } else {
      handleRelease(parts[1].charAt(0));
    }
  }catch(Exception e){
    println(e);
  }
}

void connectionLost() {
  println("connection lost");
}
