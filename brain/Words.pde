int[] wordLengths = new int[]{5, 5, 5, 5, 5, 5, 5};
int[] wordOffsets = new int[]{0, 1, 2, 3, 5, 1, 2};
boolean[] wordOn = new boolean[7];

public class Words{
  int x;
  int y;
  int numHands = 0;
  int[] wordIndices = new int[]{0, 1, 2, 3, 4, 5, 6};
  ColorWheel c;
  
  public Words(int x, int y){
    this.x = x;
    this.y = y;
    opc.ledStrip(64*5, 64, x + 31, y + 5, 1, 0, false);
    c = cp5.addColorWheel("words")
       .setPosition(65, y)
       .registerProperty("value")
       .removeProperty("ArrayValue");
  }
  
  public void draw(){
    //count up how many hands are currently touched
    int currNumHands = 0;
    for(Hand h : hands){
      if (h.isTouched()){
        currNumHands++;
      }
    }
    
    //add hands if more were touched since last frame
    while(currNumHands > numHands){
      if (numHands == wordIndices.length - 1){
        //nothing to do, the last word is always the last word
      } else {
        int chosenIndex = floor(random(numHands, wordIndices.length - 1));
        int temp = wordIndices[chosenIndex];
        wordIndices[chosenIndex] = wordIndices[numHands];
        wordIndices[numHands] = temp;
      }
      numHands++;
    }
    
    //remove hands if more were touched since last frame
    while(currNumHands < numHands){
      if (numHands == wordIndices.length){
        //nothing to do, the last word is always the first to disappear
      } else {
        int chosenIndex = floor(random(0, numHands));
        int temp = wordIndices[chosenIndex];
        wordIndices[chosenIndex] = wordIndices[numHands - 1];
        wordIndices[numHands - 1] = temp;
      }
      numHands--;
    }
    
    //update the wordOn array based on 
    // the current index arrangement and number of hands
    for(int i = 0; i < wordIndices.length; i++){
      wordOn[wordIndices[i]] = (i < numHands);
    }
    
    //draw active words
    fill(255);
    noStroke();
    int x = 0;
    for(int i = 0; i < wordLengths.length; i++){
      x += wordOffsets[i];
      if (wordOn[i]){
        fill(c.getRGB());
      } else {
        fill(0);
      }
      rect(x, 0, wordLengths[i], 10);
      x += wordLengths[i];
    }
  }
}
