int[] wordLengths = new int[]{5, 5, 5, 5, 5, 5, 5};
int[] wordOffsets = new int[]{0, 1, 2, 3, 5, 1, 2};
boolean[] wordOn = new boolean[7];

public class Words{
  int x;
  int y;
  int numWords = 0;
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
    
    currNumHands = (int)constrain(currNumHands, 0, numHands.getValue());
    int targetWords = round(currNumHands / numHands.getValue() * wordIndices.length);
    
    //add hands if more were touched since last frame
    while(targetWords > numWords){
      if (numWords == wordIndices.length - 1){
        //nothing to do, the last word is always the last word
      } else {
        int chosenIndex = floor(random(numWords, wordIndices.length - 1));
        int temp = wordIndices[chosenIndex];
        wordIndices[chosenIndex] = wordIndices[numWords];
        wordIndices[numWords] = temp;
      }
      numWords++;
    }
    
    //remove hands if more were touched since last frame
    while(targetWords < numWords){
      if (numWords == wordIndices.length){
        //nothing to do, the last word is always the first to disappear
      } else {
        int chosenIndex = floor(random(0, numWords));
        int temp = wordIndices[chosenIndex];
        wordIndices[chosenIndex] = wordIndices[numWords - 1];
        wordIndices[numWords - 1] = temp;
      }
      numWords--;
    }
    
    //update the wordOn array based on 
    // the current index arrangement and number of hands
    for(int i = 0; i < wordIndices.length; i++){
      wordOn[wordIndices[i]] = (i < numWords);
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
