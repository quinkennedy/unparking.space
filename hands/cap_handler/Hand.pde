public class Hand{
  int[][] samples;
  int sampleStart = 0;
  int id = 0;
  int y;
  int h;
  int w;
  //Boolean enabled = true;
  Toggle enabled;
  Numberbox handIndex;
  Numberbox triggerCutoff;
  Numberbox releaseDelay;
  boolean touched = false;
  int releasedAt;
  boolean released = true;
  
  public Hand(int y, int h, ControlP5 cp5){
    this.y = y;
    this.h = h;
    this.w = width - 100;
    samples = new int[2][w];
    //cp5.begin(width - 100, y);
    enabled = cp5.addToggle("enable_"+y)
      .setLabel("en")
      .setState(true)
      .setSize(10, 10)
      .setPosition(width - 25, y);
    handIndex = cp5.addNumberbox("index_"+y)
      .setLabel("index")
      .setValue(0)
      .setSize(45, 10)
      .setMin(0)
      .setMax(10)
      .setPosition(width - 100, y);
    triggerCutoff = cp5.addNumberbox("cutoff_"+y)
      .setLabel("cutoff")
      .setValue(50)
      .setSize(45, 10)
      .setMin(0)
      .setPosition(width - 100, y + 25);
    releaseDelay = cp5.addNumberbox("release_"+y)
      .setLabel("release")
      .setValue(100)
      .setSize(45, 10)
      .setMin(0)
      .setPosition(width - 50, y + 25);
       //.registerProperty("enabled")
       //.plugTo(this);
    //cp5.end();
    line(0, y, width, y);
  }
  /*
  public void enable(boolean val){
    enabled = val;
  }*/
  
  void drawGraph(int[] graph){
    line(sampleStart - 2, 
         map(graph[sampleStart - 2], min, max, y + h, y), 
         sampleStart - 1, 
         map(graph[sampleStart - 1], min, max, y + h, y));
  }
  
  public void draw(){
    //if the sensor is confirmed not touched for long enough
    // send the release message
    if (!released && !touched && releasedAt + releaseDelay.getValue() < millis()){
      released = true;
      broadcast();
    }
    //draw the graphs
    if (enabled.getState() && sampleStart > 1){
      //erase previously shown value
      stroke(255);
      line(sampleStart - 1, y, sampleStart - 1, y + h);
      //show red "progress" marker
      stroke(255, 0, 0);
      line(sampleStart, y, sampleStart, y + h);
      //draw base graph
      stroke(0, 255, 0);
      drawGraph(samples[0]);
      //draw cutoff
      stroke(0, 0, 255);
      point(sampleStart - 1, map(triggerCutoff.getValue(), min, max, y + h, y));
      //draw "filtered" graph
      stroke(0);
      drawGraph(samples[1]);
    }
  }
  
  public void addSample(int base, int filtered){
    samples[0][sampleStart] = base;
    samples[1][sampleStart] = filtered;
    sampleStart = (sampleStart + 1) % samples[0].length;
    
    if (enabled.getState()){
      max = max(max, max(base + 1, filtered + 1));
      min = min(min, min(base - 1, filtered - 1));
    
      if (touched && filtered > triggerCutoff.getValue()){
        //we might have a release, but wait until the timeout to be sure
        touched = false;
        releasedAt = millis();
      } else if (!touched && filtered < triggerCutoff.getValue()){
        //immediately accept touches
        touched = true;
        released = false;
        broadcast();
      }
    }
  }
  
  public void broadcast(){
    client.publish("hand/" + (int)handIndex.getValue(), "" + touched);
  }
}
