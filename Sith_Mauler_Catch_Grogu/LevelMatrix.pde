class LevelMatrix {
  int cols = 3;
  int rows = 3;
  float circleSize;
  PImage GroguCar;
  int[] dataArray;
  float titleY;
  color colorLevel;
  LevelMatrix(int[] dataArray, float titleY, color colorLevel) {
    this.dataArray = dataArray;
    this.titleY = titleY;
    this.colorLevel = colorLevel;
  }

  void setup() {
    float matrixWidth = min(width / 4, height);
    float matrixHeight = matrixWidth;
    circleSize = min(matrixWidth / cols, matrixHeight / rows);
    GroguCar =  loadImage("carrogrugu.png");
    float x = width / 2 - matrixWidth / 2;
    float y = titleY + height / 3 + matrixHeight / 4;
    drawMatrix(x, y);
  }

  void drawMatrix(float matrixX, float matrixY) {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {

        float posX = x * circleSize + circleSize / 2 + x;
        float posY = y * circleSize + circleSize / 2 + y;

        int index = y * cols + x;
        if (dataArray[index] == 2) {
          strokeWeight(8);
          stroke(colorLevel);
          noFill();
          ellipse(matrixX + posX, matrixY + posY, circleSize, circleSize);
        }

        if (dataArray[index] == 0 || dataArray[index] == 1) {
          strokeWeight(8);
          stroke(255);
          noFill();
          ellipse(matrixX + posX, matrixY + posY, circleSize, circleSize);
        }
        if (dataArray[index] == 1) {
          float imgSize = min(circleSize, min(GroguCar.width, GroguCar.height));
          image(GroguCar, matrixX + posX - imgSize / 2, matrixY + posY - imgSize / 2, imgSize, imgSize);
        }
        if (dataArray[index] == 3) {
          strokeWeight(8);
          stroke(colorLevel);
          noFill();
          ellipse(matrixX + posX, matrixY + posY, circleSize, circleSize);
          float imgSize = min(circleSize, min(GroguCar.width, GroguCar.height));
          image(GroguCar, matrixX + posX - imgSize / 2, matrixY + posY - imgSize / 2, imgSize, imgSize);
        }
      }
    }
  }
}
