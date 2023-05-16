class Home {

  int titleSize;
  float titleY;
  int subTitleSize;
  float subtitleY;
  float buttonHeight;
  float buttonY;
  boolean isHovered;
  boolean playButtonClicked;
  Stars stars;
  Button button;

  Home() {
    stars = new Stars();
  }

  void setup() {
    isHovered = false;
    playButtonClicked = false;
    stars.generateStars();
    cursor(ARROW);
  }

  void draw() {
    stars.drawStars();
    setTitle();
    setSubTitle();
    buttonHeight = height/15;
    buttonY = subtitleY + subTitleSize + height/10;
    button = new Button(width/3, buttonHeight, width / 2, buttonY, "PLAY!", yellow, red, width / 2, buttonY);
    button.setup();
    button.draw();
    setGrogu();
    setNames();
  }

  void setTitle() {
    String title = "Star Wars";
    titleSize = 200;
    float titleX = width/2;
    titleY = height/2 - titleSize - height/10;
    fill(yellow);
    textAlign(CENTER, CENTER);
    textFont(StarJedi);
    textSize(titleSize);
    text(title, titleX, titleY);
  }
  void setSubTitle() {
    String subtitle = "Sith Mauler: Catch Grogu!";
    subTitleSize = 80;
    float subtitleX = width/2;
    subtitleY = titleY + titleSize + height/40;
    fill(yellow);
    textAlign(CENTER, CENTER);
    textFont(DistantGalaxy);
    textSize(subTitleSize);
    text(subtitle, subtitleX, subtitleY);
  }

  void setNames() {
    fill(yellow);
    textAlign(LEFT, BOTTOM);
    textFont(Mandalorian);
    textSize(50);
    text("Andrea Agudelo", 20, height - height/7);
    text("David Espitia", 20, height - height/10);
    text("Laura Piraneque", 20, height - height/18);
  }
  void setGrogu() {
    float groguX = width / 2 - Grogu.width / 2;
    float groguY = buttonY + buttonHeight + height/10;
    image(Grogu, groguX, groguY);
  }
  void mousePressed() {
    if (button.getIsButtonHovered()) {
      playButtonClicked = true;
    }
  }
  boolean isButtonClicked() {
    return playButtonClicked;
  }
  void setButtonClicked(boolean state) {
    this.playButtonClicked = state;
  }
}
