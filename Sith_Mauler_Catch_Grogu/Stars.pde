class Stars {
  float[] starX;
  float[] starY;
  float[] starDiameter;
  float[] starAlpha;
  int starCounter;

  Stars() {
    starX = new float[200];
    starY = new float[200];
    starDiameter = new float[200];
    starAlpha = new float[200];
    starCounter = 0;
  }

  void setup() {
    generateStars();
  }

  void generateStars() {
    for (int i = 0; i < 200; i++) {
      starX[i] = random(width);
      starY[i] = random(height);
      starDiameter[i] = random(1, 5);
      starAlpha[i] = random(50, 255);
      starCounter++;
    }
  }

  void drawStars() {
    for (int i = 0; i < starCounter; i++) {
      fill(255, starAlpha[i]);
      noStroke();
      ellipse(starX[i], starY[i], starDiameter[i], starDiameter[i]);
    }
  }
}
