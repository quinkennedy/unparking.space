void initCP5(){
  cp5 = new ControlP5(this);
  ArrayList<String> ports = new ArrayList<String>(Arrays.asList(Serial.list()));
  int nbw = 100;
  int nbh = 20;
  int x = 0, y = 0;
  Group g1 = cp5.addGroup("settings")
                .setPosition(width - nbw * 2, 0);
  cp5.addNumberbox("w1s")
     .setValue(wordOffsets[0])
     .setPosition(x++ * nbw, y * nbh * 2)
     .setGroup(g1);
  cp5.addNumberbox("w1l", wordLengths[0], x-- * nbw, y++ * nbh * 2, nbw, nbh).setGroup(g1);
  cp5.addNumberbox("w2s")
     .setValue(wordOffsets[1])
     .setPosition(x++ * nbw, y * nbh * 2)
     .setGroup(g1);
  cp5.addNumberbox("w2l", wordLengths[1], x-- * nbw, y++ * nbh * 2, nbw, nbh).setGroup(g1);
  cp5.addNumberbox("w3s")
     .setValue(wordOffsets[2])
     .setPosition(x++ * nbw, y * nbh * 2)
     .setGroup(g1);
  cp5.addNumberbox("w3l", wordLengths[2], x-- * nbw, y++ * nbh * 2, nbw, nbh).setGroup(g1);
  cp5.addNumberbox("w4s")
     .setValue(wordOffsets[3])
     .setPosition(x++ * nbw, y * nbh * 2)
     .setGroup(g1);
  cp5.addNumberbox("w4l", wordLengths[3], x-- * nbw, y++ * nbh * 2, nbw, nbh).setGroup(g1);
  cp5.addNumberbox("w5s")
     .setValue(wordOffsets[4])
     .setPosition(x++ * nbw, y * nbh * 2)
     .setGroup(g1);
  cp5.addNumberbox("w5l", wordLengths[4], x-- * nbw, y++ * nbh * 2, nbw, nbh).setGroup(g1);
  cp5.addNumberbox("w6s")
     .setValue(wordOffsets[5])
     .setPosition(x++ * nbw, y * nbh * 2)
     .setGroup(g1);
  cp5.addNumberbox("w6l", wordLengths[5], x-- * nbw, y++ * nbh * 2, nbw, nbh).setGroup(g1);  
  cp5.addNumberbox("w7s")
     .setValue(wordOffsets[6])
     .setPosition(x++ * nbw, y * nbh * 2)
     .setGroup(g1);
  cp5.addNumberbox("w7l", wordLengths[6], x-- * nbw, y++ * nbh * 2, nbw, nbh).setGroup(g1);
  
  cp5.addScrollableList("portSelect")
     .setPosition(x * nbw, y* nbh * 2)
     .addItems(ports)
     .setGroup(g1);
  cp5.getProperties().addSet("ignored");
  cp5.getProperties().move(cp5.getController("portSelect"), "default", "ignored");
}

public void portSelect(int n){
  serial = new Serial(this, Serial.list()[n], 9600);
  serial.bufferUntil('\n');
}

public void w1s(int v){
  wordOffsets[0] = v;
}

public void w1l(int v){
  wordLengths[0] = v;
}

public void w2s(int v){
  wordOffsets[1] = v;
}

public void w2l(int v){
  wordLengths[1] = v;
}

public void w3s(int v){
  wordOffsets[2] = v;
}

public void w3l(int v){
  wordLengths[2] = v;
}

public void w4s(int v){
  wordOffsets[3] = v;
}

public void w4l(int v){
  wordLengths[3] = v;
}

public void w5s(int v){
  wordOffsets[4] = v;
}

public void w5l(int v){
  wordLengths[4] = v;
}

public void w6s(int v){
  wordOffsets[5] = v;
}

public void w6l(int v){
  wordLengths[5] = v;
}

public void w7s(int v){
  wordOffsets[6] = v;
}

public void w7l(int v){
  wordLengths[6] = v;
}
