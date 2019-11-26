public class Ambient{
  int x;
  int y;
  ColorWheel c;
  float period = 10000;
  
  public Ambient(int x, int y){
    this.x = x;
    this.y = y;
    opc.ledStrip(64*4, 64, x + 31, y + 5, 1, 0, false);
    c = cp5.addColorWheel("ambient")
       .setPosition(65, y)
       .registerProperty("value")
       .removeProperty("ArrayValue");
  }
  
  public void draw(){
    int startPopAt = (int)(lastInteractionAt + ambientTimeout.getValue() * 1000);
    int popX = millis() - startPopAt;
    color currColor = c.getRGB();
    if (popX > 0){
      float val = sin(popX / period * TWO_PI);
      if (val > 0){
        currColor = lerpColor(currColor, color(255), val);
      } else {
        currColor = lerpColor(currColor, color(0), -val);
      }
    }
    fill(currColor);
    noStroke();
    rect(x, y, 64, 10);
  }
}
