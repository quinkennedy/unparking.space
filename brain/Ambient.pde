public class Ambient{
  int x;
  int y;
  ColorWheel c;
  
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
    fill(c.getRGB());
    noStroke();
    rect(x, y, 64, 10);
  }
}
