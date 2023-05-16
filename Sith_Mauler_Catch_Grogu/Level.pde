class Level {
  color colorLevel;
  String title;
  String points;
  Stars stars;
  int titleSize;
  float titleX;
  float titleY;
  LightsaberTimeout lightsaberTimeout;
  LevelMatrix levelMatrix;
  PImage GroguCar;
  PImage GroguAndMando;
  int[] arrayLevel;
  float backLevelButtonWidth;
  float backLevelButtonHeight;
  float backLevelButtonX;
  float backLevelButtonY;
  Button backLevelButton;
  boolean isBackButtonHovered;
  boolean backButtonClicked;

  Level(color colorLevel, String title, String points, int[] arrayLevel) {
    this.colorLevel = colorLevel;
    this.title = title;
    this.points = points;
    stars = new Stars();
    this.arrayLevel = arrayLevel;
  }

  void setup() {
    cursor(ARROW);
    stars.setup();
    titleSize = 180;
    titleX = width/2;
    titleY = height/20 + titleSize;
    GroguAndMando = loadImage("mandoandgrogu.png");
    backLevelButtonWidth = width/5;
    backLevelButtonHeight = height/15;
    backLevelButtonX = width/20 +  backLevelButtonWidth/3;
    backLevelButtonY = height - height/30 - backLevelButtonHeight/3;
    isBackButtonHovered = false;
    backButtonClicked = false;
    backLevelButton = new Button(backLevelButtonWidth, backLevelButtonHeight, backLevelButtonX, backLevelButtonY, "EXIT", yellow, red, backLevelButtonX,
      backLevelButtonY);
    backLevelButton.setup();
  }
  void startCountDown() {
    //5 minutos => 300000
    lightsaberTimeout = new LightsaberTimeout(30000, colorLevel);
  }
  void draw() {
    stars.drawStars();
    setTitle();
    lightsaberTimeout.update();
    if (!lightsaberTimeout.isTimeoutReached()) {
      float progress = map(millis(), lightsaberTimeout.startTime, lightsaberTimeout.startTime + lightsaberTimeout.timeoutDuration, 0, width / 1.8 - 60);
      lightsaberTimeout.drawLightsaber(progress);
      levelMatrix = new LevelMatrix(arrayLevel, titleY, colorLevel);
      levelMatrix.setup();
    } else {
      lightsaberTimeout.drawTimeoutMessage();
      setGroguAndMando();
    }
    setPointsLeyend();
    setPoints();
    backLevelButton.draw();
  }
  void setTitle() {
    fill(colorLevel);
    textAlign(CENTER, CENTER);
    textFont(StarJedi);
    textSize(titleSize);
    text(this.title, titleX, titleY);
  }
  void setPointsLeyend() {
    fill(yellow);
    textAlign(CENTER, CENTER);
    textFont(DeathStar);
    textSize(80);
    text("Your points:", titleX, titleY+height/7);
  }
  void setPoints() {
    fill(255);
    textAlign(CENTER, CENTER);
    textFont(DeathStar);
    textSize(150);
    text(this.points, titleX, titleY+height/4);
  }
  void setGroguAndMando() {
    float groguAndMandoX = width / 2 - GroguAndMando.width / 2;
    float groguAndMandoY =  titleY+height/3 + GroguAndMando.height / 2;
    GroguAndMando.resize(400, 0);
    image(GroguAndMando, groguAndMandoX, groguAndMandoY);
  }
  void setPoints(int points) {
    this.points = ""+points;
  }
  void setArrayLevel(int[] arrayLevel) {
    this.arrayLevel = arrayLevel;
  }

  boolean isLevelTimeOut() {
    return lightsaberTimeout.isTimeoutReached();
  }
  void mousePressed() {
    if (backLevelButton.getIsButtonHovered()) {
      backButtonClicked = true;
    }
  }
  boolean isBackButtonClicked() {
    return backButtonClicked;
  }
  void setBackButtonClicked(boolean state) {
    this.backButtonClicked = state;
  }
}
