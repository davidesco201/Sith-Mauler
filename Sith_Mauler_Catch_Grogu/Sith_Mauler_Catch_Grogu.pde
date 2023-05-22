import processing.serial.*; //<>//
Serial myPort;
String serialValue;


Home home;
Difficulty difficulty;
Level level1;
Level level2;
Level level3;

PFont StarJedi;
PFont DistantGalaxy;
PFont DeathStar;
PFont Mandalorian;

PImage Grogu;
PImage GroguHead;
PImage MandoHead;
PImage DarkTrooperHead;
PImage MoffGideonHead;
PImage TIE;
PImage TrooperHead;

color yellow = color(254, 198, 3);
color red = color(232, 21, 34);
color green = color(21, 239, 9);
color blue = color(1, 107, 170);

int starJediFontSize = 48;
int distantGalaxyFontSize = 48;
int deathStarFontSize = 48;
int mandalorianFontSize = 48;

boolean inHome;
boolean inDifficulty;
boolean inLevel1;
boolean inLevel2;
boolean inLevel3;

String pointsString;
int[] arrayLevel;
int pointsCounter;

void setup() {
  fullScreen();
  
  myPort = new Serial(this, Serial.list()[3], 9600); 
  myPort.bufferUntil('\n');

  pointsString = "0";
  arrayLevel = new int[]{0, 0, 0, 0, 0, 0, 0, 0, 0};
  pointsCounter = 0;

  setFontsAndImages();
  setScreens();

  inHome = true;
  inDifficulty = false;
  inLevel1 = false;
  inLevel2 = false;
  inLevel3 = false;
}

void draw() {
  cursor(ARROW);
  background(0);
  if (inHome) {
    difficulty.setBackButtonClicked(false);
    home.draw();
    if (home.isButtonClicked()) {
      setInHome(false);
      setInDifficulty(true);
    }
  } else if (inDifficulty) {
    home.setButtonClicked(false);
    level1.setBackButtonClicked(false);
    level2.setBackButtonClicked(false);
    level3.setBackButtonClicked(false);
    difficulty.draw();
    if (difficulty.isLevel1ButtonClicked()) {
      setInDifficulty(false);
      setDefaultLevel(level1);
      setInLevel1(true);
      level1.startCountDown();
    } else if (difficulty.isLevel2ButtonClicked()) {
      setInDifficulty(false);
      setDefaultLevel(level2);
      setInLevel2(true);
      level2.startCountDown();
    } else if (difficulty.isLevel3ButtonClicked()) {
      setInDifficulty(false);
      setDefaultLevel(level3);
      setInLevel3(true);
      level3.startCountDown();
    } else if (difficulty.isBackButtonClicked()) {
      setInDifficulty(false);
      setInHome(true);
    }
  } else if (inLevel1) {
    difficulty.setLevel1ButtonClicked(false);

    level1.draw();
    if (level1.isLevelTimeOut()) {
      myPort.write('4');
    }
    if (level1.isBackButtonClicked()) {
      setInHome(true);
      setInLevel1(false);
    }
  } else if (inLevel2) {
    difficulty.setLevel2ButtonClicked(false);

    level2.draw();
    if (level2.isLevelTimeOut()) {
      myPort.write('4');
    }
    if (level2.isBackButtonClicked()) {
      setInHome(true);
      setInLevel2(false);
    }
  } else if (inLevel3) {
    difficulty.setLevel3ButtonClicked(false);

    level3.draw();
    if (level3.isLevelTimeOut()) {
      myPort.write('4');
    }
    if (level3.isBackButtonClicked()) {
      setInHome(true);
      setInLevel3(false);
    }
  }
}

void serialEvent(Serial myPort) {
  try {
    String data = myPort.readString();
    if (data != null) {
      data = data.trim();
      if (data.contains("P:")) {
        String[] points = split(data, ':');
        pointsCounter++;
        String[] values = split(points[1], ',');
        fillArrayLevel(values);
        if (inLevel1) {
          level1.setPoints(pointsCounter);
          level1.setArrayLevel(arrayLevel);
        } else if (inLevel2) {
          level2.setPoints(pointsCounter);
          level2.setArrayLevel(arrayLevel);
        } else if (inLevel3) {
          level3.setPoints(pointsCounter);
          level3.setArrayLevel(arrayLevel);
        }
      } else {
        String[] values = split(data, ',');
        fillArrayLevel(values);
      }
    }
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

void mousePressed() {
  if (inHome) {
    home.mousePressed();
  } else if (inDifficulty) {
    difficulty.mousePressed();
    if (difficulty.isLevel1ButtonClicked()) {
      myPort.write('1');
    }
    if (difficulty.isLevel2ButtonClicked()) {
      myPort.write('2');
    }
    if (difficulty.isLevel3ButtonClicked()) {
      myPort.write('3');
    }
    if (difficulty.isBackButtonClicked()) {
      setInDifficulty(false);
      setInHome(true);
      myPort.write('4');
    }
  } else if (inLevel1) {
    level1.mousePressed();
    if (level1.isBackButtonClicked()) {
      myPort.write('4');
    }
  } else if (inLevel2) {
    level2.mousePressed();
    if (level2.isBackButtonClicked()) {
      myPort.write('4');
    }
  } else if (inLevel3) {
    level3.mousePressed();
    if (level3.isBackButtonClicked()) {
      myPort.write('4');
    }
  }
}


void setScreens() {
  background(0);
  home = new Home();
  home.setup();
  difficulty = new Difficulty();
  difficulty.setup();
  level1 = new Level(green, "Level 1", pointsString, arrayLevel);
  level2 = new Level(blue, "Level 2", pointsString, arrayLevel);
  level3 = new Level(red, "Level 3", pointsString, arrayLevel);
  level1.setup();
  level2.setup();
  level3.setup();
}

void setFontsAndImages() {
  StarJedi = createFont("StarJediRounded-jW3R.ttf", starJediFontSize);
  DistantGalaxy = createFont("SF Distant Galaxy Outline.ttf", distantGalaxyFontSize);
  DeathStar = createFont("DeathStar-VmWB.ttf", deathStarFontSize);
  Mandalorian = createFont("mandalor.ttf", mandalorianFontSize);

  Grogu = loadImage("grogu1.png");
  GroguHead = loadImage("grogu_head.png");
  MandoHead = loadImage("mando.png");
  DarkTrooperHead = loadImage("darktrooper.png");
  MoffGideonHead = loadImage("EmojiBlitzMoffGideon-PowerUp.png");
  TIE = loadImage("TIE.png");
  TrooperHead = loadImage("trooper.png");
}

void fillArrayLevel(String[] values) {
  for (int i = 0; i < values.length; i++) {
    arrayLevel[i] = int(values[i]);
  }
}

void setDefaultLevel(Level level) {
  arrayLevel = new int[]{0, 0, 0, 0, 0, 0, 0, 0, 0};
  pointsCounter = 0;
  level.setPoints(pointsCounter);
  level.setArrayLevel(arrayLevel);
}


void setInHome(boolean state) {
  this.inHome = state;
}
void setInDifficulty(boolean state) {
  this.inDifficulty = state;
}
void setInLevel1(boolean state) {
  this.inLevel1 = state;
}
void setInLevel2(boolean state) {
  this.inLevel2 = state;
}
void setInLevel3(boolean state) {
  this.inLevel3 = state;
}
