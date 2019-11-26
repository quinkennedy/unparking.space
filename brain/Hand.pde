public class Hand{
  boolean hasLEDs = false;
  boolean touched = false;
  int touchedAt;
  int x, y;
  //color baseColor = color(255, 255, 255);
  //color baseColor = color(218, 165, 32);
  //color touchedColor = color(155, 0, 155);
  int period = 5000;
  int waitUntil;
  color fadeFrom;
  int touchFadeInTime = 300;
  int numLEDs = 6;
  
  public Hand(){}
  
  public Hand(int x, int y, int offset){
    this.x = x;
    this.y = y;
    hasLEDs = true;
    opc.ledStrip(offset, numLEDs, x + numLEDs / 2 - 1, y + 5, 1, 0, false);
  }
  
  public boolean isTouched(){
    return touched;
  }
  
  public void touched(){
    if (!touched){
      fadeFrom = currBase();
      touchedAt = millis();
      touched = true;
    }
  }
  
  public void released(){
    touched = false;
  }
  
  public color currBase(){
    int now = millis();
    float progress = constrain(map(now, waitUntil, waitUntil + period/2, 0, 1), 0, 1);
    if (progress == 1){
      waitUntil = now + (int)random(500, 5000);
    }
    progress = sin(progress * PI);
    return lerpColor(color(0), handBaseColor.getRGB(), progress * .8);
  }
  
  public void draw(){
    if (hasLEDs){
      int now = millis();
      color c = color(255,0,0);
      if (touched){
        //glowing yellow
        float progress = constrain(map(now, touchedAt, touchedAt + touchFadeInTime, 0, 1), 0, 1);
        progress = ((-cos(progress * PI) + 1) / 2); // tween in/out
        c = lerpColor(fadeFrom, handTouchColor.getRGB(), progress);
      } else {
        c = currBase();
      }
      fill(c);
      noStroke();
      rect(x, y, numLEDs, 10);
    }
  }
}
