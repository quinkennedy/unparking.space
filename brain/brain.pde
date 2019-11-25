import controlP5.*;
import processing.serial.*;
import java.util.*;

ControlP5 cp5;
Serial serial;
OPC opc;

Hand[] hands;
Words words;

void setup(){
  size(400, 400);
  initCP5();
  initOPC();
}

void draw(){
  background(0);
}

void handleTouch(char c){
  switch(c){
    case '1':
    hands[0].touched();
    break;
    case '2':
    hands[1].touched();
    break;
    case '3':
    hands[2].touched();
    break;
    case '4':
    hands[3].touched();
    break;
    case '5':
    hands[4].touched();
    break;
    case '6':
    hands[5].touched();
    break;
    case '7':
    hands[6].touched();
    break;
  }
}

void handleRelease(char c){
  switch(c){
    case '1':
    hands[0].released();
    break;
    case '2':
    hands[1].released();
    break;
    case '3':
    hands[2].released();
    break;
    case '4':
    hands[3].released();
    break;
    case '5':
    hands[4].released();
    break;
    case '6':
    hands[5].released();
    break;
    case '7':
    hands[6].released();
    break;
  }
}

void serialEvent(Serial port){
  String in = port.readString();
  print("got " + in);
  String[] pieces = in.trim().split(" ");
  if (pieces.length == 2){
    switch(pieces[1]){
      case "touched":
      handleTouch(pieces[0].charAt(0));
      break;
      case "release":
      handleRelease(pieces[0].charAt(0));
      break;
    }
  }
}

void keyPressed() {
  switch(key){
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
  opc.ledStrip(64*5, 64, 31, 5, 1, 0, false);
  hands = new Hand[]{
    new Hand(this, 0, 20, 64*1),
    new Hand(this, 6, 20, 64*1+6),
    new Hand(this, 12, 20, 64*3),
    new Hand(this, 18, 20, 64*3+6),
    new Hand(),
    new Hand(),
    new Hand()
  };
  words = new Words(this);
}
