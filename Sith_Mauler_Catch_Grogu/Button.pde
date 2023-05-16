class Button {
  float buttonWidth;
  float buttonHeight;
  float buttonX;
  float buttonY;
  String text;
  color buttonColor;
  float cornerRadius;
  float texButtontSize;
  boolean isButtonHovered;
  color hoverButtonColor;
  float textX;
  float textY;

  Button(float buttonWidth, float buttonHeight, float buttonX, float buttonY, String text, color buttonColor, color hoverButtonColor, float textX, float textY) {
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.text = text;
    this.buttonColor = buttonColor;
    this.hoverButtonColor = hoverButtonColor;
    this.textX = textX;
    this.textY = textY;
  }

  void setup() {
    cornerRadius = 10;
    texButtontSize = 80;
    isButtonHovered = false;
  }

  void draw() {
    isButtonHovered = isMouseOverButton(this.buttonX, this.buttonWidth, this.buttonY, this.buttonHeight);
    if (isButtonHovered) {
      cursor(HAND);
      fill(this.hoverButtonColor);
    } else {
      fill(this.buttonColor);
    }
    rectMode(CENTER);
    noStroke();
    rect(this.buttonX, this.buttonY, this.buttonWidth, this.buttonHeight, cornerRadius);

    fill(0);
    textFont(DeathStar);
    textSize(texButtontSize);
    text(this.text, this.textX, this.textY);
  }

  boolean isMouseOverButton(float buttonX, float buttonWidth, float buttonY, float buttonHeight) {
    return mouseX > buttonX - buttonWidth / 2 && mouseX < buttonX + buttonWidth / 2 &&
      mouseY > buttonY - buttonHeight / 2 && mouseY < buttonY + buttonHeight / 2;
  }
  boolean getIsButtonHovered() {
    return this.isButtonHovered;
  }
}
