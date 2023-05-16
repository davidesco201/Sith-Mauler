class Difficulty {
  float level1ButtonWidth;
  float level1ButtonHeight;
  float level1ButtonX;
  float level1ButtonY;
  boolean isLevel1ButtonHovered;
  boolean level1ButtonClicked;
  float level2ButtonWidth;
  float level2ButtonHeight;
  float level2ButtonX;
  float level2ButtonY;
  boolean isLevel2ButtonHovered;
  boolean level2ButtonClicked;
  float level3ButtonWidth;
  float level3ButtonHeight;
  float level3ButtonX;
  float level3ButtonY;
  boolean isLevel3ButtonHovered;
  boolean level3ButtonClicked;
  float rotationAngle = 0;
  float rotationDirection = 1;
  float backButtonWidth;
  float backButtonHeight;
  float backButtonX;
  float backButtonY;
  float level1ButtonTextX;
  float level1ButtonTextY;
  float level2ButtonTextX;
  float level2ButtonTextY;
  float level3ButtonTextX;
  float level3ButtonTextY;
  boolean isBackButtonHovered;
  boolean backButtonClicked;

  Stars stars;
  Button buttonLevel1;
  Button buttonLevel2;
  Button buttonLevel3;
  Button backButton;
  PImage[] images = {GroguHead, MandoHead, DarkTrooperHead, MoffGideonHead, TIE, TrooperHead};


  Difficulty() {
    this.stars = new Stars();
    this.level1ButtonWidth = width/3;
    this.level1ButtonHeight = height/15;
    this.level1ButtonX = width / 2 ;
    this.level1ButtonY = height/ 2.2 - level1ButtonHeight/2;
    this.level2ButtonWidth = width/3;
    this.level2ButtonHeight = height/15;
    this.level2ButtonX = width / 2;
    this.level2ButtonY = level1ButtonY + level1ButtonHeight + height/25;
    this.level3ButtonWidth = width/3;
    this.level3ButtonHeight = height/15;
    this.level3ButtonX = width / 2;
    this.level3ButtonY = level2ButtonY + level2ButtonHeight + height/25;
    this.backButtonWidth = width/5;
    this.backButtonHeight = height/15;
    this.backButtonX = width/20 +  backButtonWidth/3;
    this.backButtonY = height - height/30 - backButtonHeight/3;
    this.level1ButtonTextX  = level1ButtonX - width/15;
    this.level1ButtonTextY = level1ButtonY + height/30;
    this.level2ButtonTextX = level2ButtonX - width/15;
    this.level2ButtonTextY = level2ButtonY + height/30;
    this.level3ButtonTextX = level3ButtonX - width/15;
    this.level3ButtonTextY = level3ButtonY + height/30;
  }
  void setup() {
    buttonLevel1 = new Button(level1ButtonWidth, level1ButtonHeight, level1ButtonX, level1ButtonY, "LEVEL I", yellow, green, level1ButtonTextX, level1ButtonTextY);
    buttonLevel1.setup();
    buttonLevel2 = new Button(level2ButtonWidth, level2ButtonHeight, level2ButtonX, level2ButtonY, "LEVEL II", yellow, blue, level2ButtonTextX, level2ButtonTextY);
    buttonLevel2.setup();
    buttonLevel3 = new Button(level3ButtonWidth, level3ButtonHeight, level3ButtonX, level3ButtonY, "LEVEL III", yellow, red, level3ButtonTextX, level3ButtonTextY);
    buttonLevel3.setup();
    isLevel1ButtonHovered = false;
    level1ButtonClicked = false;
    isLevel2ButtonHovered = false;
    level2ButtonClicked = false;
    isLevel3ButtonHovered = false;
    level3ButtonClicked = false;
    isBackButtonHovered = false;
    backButtonClicked = false;
    stars.setup();
  }

  void draw() {
    stars.drawStars();
    buttonLevel1.draw();
    buttonLevel2.draw();
    buttonLevel3.draw();
    setImage(images);
    rotationAngle += 1 * rotationDirection;
    if (rotationAngle >= 10 || rotationAngle <= -15) {
      rotationDirection *= -1;
    }
    backButton = new Button(backButtonWidth, backButtonHeight, backButtonX, backButtonY, "BACK", yellow, red, backButtonX - width/20, backButtonY + height/30);
    backButton.setup();
    backButton.draw();
  }

  void mousePressed() {
    if (buttonLevel1.getIsButtonHovered()) {
      level1ButtonClicked = true;
    }
    if (buttonLevel2.getIsButtonHovered()) {
      level2ButtonClicked = true;
    }
    if (buttonLevel3.getIsButtonHovered()) {
      level3ButtonClicked = true;
    }
    if (backButton.getIsButtonHovered()) {
      backButtonClicked = true;
    }
  }
  boolean isLevel1ButtonClicked() {
    return level1ButtonClicked;
  }
  void setLevel1ButtonClicked(boolean state) {
    this.level1ButtonClicked = state;
  }

  boolean isLevel2ButtonClicked() {
    return level2ButtonClicked;
  }
  void setLevel2ButtonClicked(boolean state) {
    this.level2ButtonClicked = state;
  }
  boolean isLevel3ButtonClicked() {
    return level3ButtonClicked;
  }
  void setLevel3ButtonClicked(boolean state) {
    this.level3ButtonClicked = state;
  }

  boolean isBackButtonClicked() {
    return this.backButtonClicked;
  }
  void setBackButtonClicked(boolean state) {
    this.backButtonClicked = state;
  }

  void setImage(PImage[] images) {
    float spacing = height * 0.1;

    float group1X = width * 0.1;
    float group2X = width * 0.75;
    float startY = height * 0.15;

    float xGroup1 = group1X;
    float xGroup2 = group2X;
    float y = startY;

    for (int i = 0; i < images.length; i++) {
      images[i].resize(width/8, 0);

      pushMatrix();

      if (i < 3) {
        translate(xGroup1, y);
      } else {
        translate(xGroup2, y);
      }

      rotate(radians(rotationAngle));

      image(images[i], 0, 0);

      popMatrix();

      y += images[i].height + spacing;
      if (i == 2) {
        y = startY;
      }
    }
  }
}
