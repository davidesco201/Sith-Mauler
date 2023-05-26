/* //<>//
  Import Imnim library to play music.
  Declare the Minim object as minim.
  Declare the AudioPlayer object as player.
*/
import ddf.minim.*;
import ddf.minim.spi.*;
Minim minim;
AudioPlayer player;

/*
  Import Serial library to communicate with the Arduino by the Serial Port.
  Declare the Serial object as myPort.
  Declare the serialValue as the variable that gets the values from Arduino.
*/
import processing.serial.*;
Serial myPort;
String serialValue;


/*
  Declare the instances of each view: Home, Difficulty, and 3 Game Levels
*/
Home home;
Difficulty difficulty;
Level level1;
Level level2;
Level level3;

/*
  Declare the instances of the imported Fonts.
*/
PFont StarJedi;
PFont DistantGalaxy;
PFont DeathStar;
PFont Mandalorian;

/*
  Declare the instances of the imported images.
*/
PImage Grogu;
PImage GroguHead;
PImage MandoHead;
PImage DarkTrooperHead;
PImage MoffGideonHead;
PImage TIE;
PImage TrooperHead;


/*
  Initialize the colors of the game. 
*/
color yellow = color(254, 198, 3);
color red = color(232, 21, 34);
color green = color(21, 239, 9);
color blue = color(1, 107, 170);

/*
  Initialize the default font size of each Font.
*/

int starJediFontSize = 48;
int distantGalaxyFontSize = 48;
int deathStarFontSize = 48;
int mandalorianFontSize = 48;


/*
  Declare the state control view variables each variable will be toggled to allow the view draw or not. 
*/
boolean inHome;
boolean inDifficulty;
boolean inLevel1;
boolean inLevel2;
boolean inLevel3;


/*
  Declare the variables of the level punctuation: the points (as an int and an string) 
   and the array level that would be scanned to represent it as a matrix.
*/
String pointsString;
int[] arrayLevel;
int pointsCounter;

void setup() {
  fullScreen();
  
  /*
    Initialize the serial instance with params (parent, portName, baudRate).
    Set the String '\n' to buffer unitl brefore calling the serialEvent method.
  */
  myPort = new Serial(this, Serial.list()[1], 9600); 
  myPort.bufferUntil('\n');

  /*
    Set default values to the points and the array level variables.
  */
  pointsString = "0";
  arrayLevel = new int[]{0, 0, 0, 0, 0, 0, 0, 0, 0};
  pointsCounter = 0;
  //Initialize the minim instance
  minim = new Minim(this);
  //Play Song
  player = minim.loadFile("starfleet-command-150605.mp3"); 
  player.play();
  // Reference: Pixabay. 2023. Main Title - Starfleet Command. [Online audio track]. Available: https://pixabay.com/music/main-title-starfleet-command-150605/
  
  /*
    Set images, fonts and views.
  */
  setFontsAndImages();
  setScreens();

  /*
    Set default values control view variables.
  */
  inHome = true;
  inDifficulty = false;
  inLevel1 = false;
  inLevel2 = false;
  inLevel3 = false;
}

void draw() {
  cursor(ARROW);
  background(0);
  /*
    If the view boolean value is true then will draw it and set false the state of the button that leads to that view.
  */
  if (inHome) {
    // The back Button from Difficulty view it's set as false clicked
    difficulty.setBackButtonClicked(false);
    home.draw();
    //If the play button was clicked then it changes the state of the view Home and Difficulty
    if (home.isPlayButtonClicked()) {
      setInHome(false);
      setInDifficulty(true);
    }     
  } else if (inDifficulty) {
    // The play Button of Home view is set as false clicked and the back button of each Level view as well
    home.setPlayButtonClicked(false);
    level1.setBackButtonClicked(false);
    level2.setBackButtonClicked(false);
    level3.setBackButtonClicked(false);
    difficulty.draw();
    /*
      If any level button was clicked then it will change the states between the Difficulty view and the clicked Level.
      Then it will set default values of the Level (points and the array).
      And it will start the count down of the level. 
            
      Finally, if the back button of the Difficulty view was clicked it will change the states between Home and Difficulty
    */
    if (difficulty.isLevel1ButtonClicked()) {
      setInDifficulty(false);
      setInLevel1(true);
      setDefaultLevel(level1);
      level1.startCountDown();
    } else if (difficulty.isLevel2ButtonClicked()) {
      setInDifficulty(false);
      setInLevel2(true);
      setDefaultLevel(level2);
      level2.startCountDown();
    } else if (difficulty.isLevel3ButtonClicked()) {
      setInDifficulty(false);
      setInLevel3(true);
      setDefaultLevel(level3);
      level3.startCountDown();
    } else if (difficulty.isBackButtonClicked()) {
      setInDifficulty(false);
      setInHome(true);
    }    
  /*
    If any level view state is true it will set as false the level button of Difficulty and draw the level.
    If the count down of the level has finished it will send by the Serial Port a 4 to be interpreted by the Arduino.
    If the back button of the level was clicked it will change the states between the Level and Home.  
  */
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

/*
  Every time the serialEvent is triggered it will read the data received, 
  trim, and split to be converted as an array and to add a point (or not) to the score. 
  
  These values would be passed depending on the level that it´s being played.
  
  If any error is thrown it will be cath and printed in the terminal.
*/
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
    if(home.isPlayButtonClicked()){
      AudioPlayer newPlayer = minim.loadFile("cinematic-battle-music-star-wars-style-148641.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Cinematic Battle Music (Star Wars Style). [Online audio track]. Available: https://pixabay.com/music/main-title-cinematic-battle-music-star-wars-style-148641/
      changeSong(newPlayer);
    }
  } else if (inDifficulty) {
    difficulty.mousePressed();
    if (difficulty.isLevel1ButtonClicked()) {
      //If level 1 button is clicked then it will send by the Serial Port a 1 to be interpreted by the Arduino.
      myPort.write('1');
      
      AudioPlayer newPlayer = minim.loadFile("space-adventures-orchestral-music-star-wars-style-139660.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Space Adventures (Orchestral Music, Star Wars Style). [Online audio track]. Available: https://pixabay.com/music/main-title-space-adventures-orchestral-music-star-wars-style-139660/
      changeSong(newPlayer);
    }
    if (difficulty.isLevel2ButtonClicked()) {
      //If level 2 button is clicked then it will send by the Serial Port a 2 to be interpreted by the Arduino.
      myPort.write('2');
      
      AudioPlayer newPlayer = minim.loadFile("space-adventures-orchestral-music-star-wars-style-139660.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Space Adventures (Orchestral Music, Star Wars Style). [Online audio track]. Available: https://pixabay.com/music/main-title-space-adventures-orchestral-music-star-wars-style-139660/
      changeSong(newPlayer);
    }
    if (difficulty.isLevel3ButtonClicked()) {
      //If level 3 button is clicked then it will send by the Serial Port a 3 to be interpreted by the Arduino.
      myPort.write('3');
      
      AudioPlayer newPlayer = minim.loadFile("space-adventures-orchestral-music-star-wars-style-139660.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Space Adventures (Orchestral Music, Star Wars Style). [Online audio track]. Available: https://pixabay.com/music/main-title-space-adventures-orchestral-music-star-wars-style-139660/
      changeSong(newPlayer);
    }
    if (difficulty.isBackButtonClicked()) {
      /*
        If back button is clicked then it will send by the Serial Port a 4 to be interpreted by the Arduino
        And change states between Home and Difficulty views. 
      */
      setInDifficulty(false);
      setInHome(true);
      myPort.write('4');
      
      AudioPlayer newPlayer = minim.loadFile("starfleet-command-150605.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Starfleet Command. [Online audio track]. Available: https://pixabay.com/music/main-title-starfleet-command-150605/
      changeSong(newPlayer);
    }
  } else if (inLevel1) {
    level1.mousePressed();
    if (level1.isBackButtonClicked()) {
      //If back button is clicked then it will send by the Serial Port a 4 to be interpreted by the Arduino
      myPort.write('4');
      
      AudioPlayer newPlayer = minim.loadFile("starfleet-command-150605.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Starfleet Command. [Online audio track]. Available: https://pixabay.com/music/main-title-starfleet-command-150605/
      changeSong(newPlayer);
    }
  } else if (inLevel2) {
    level2.mousePressed();
    if (level2.isBackButtonClicked()) {
      //If back button is clicked then it will send by the Serial Port a 4 to be interpreted by the Arduino
      myPort.write('4');
      
      AudioPlayer newPlayer = minim.loadFile("starfleet-command-150605.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Starfleet Command. [Online audio track]. Available: https://pixabay.com/music/main-title-starfleet-command-150605/
      changeSong(newPlayer);
    }
  } else if (inLevel3) {
    level3.mousePressed();
    if (level3.isBackButtonClicked()) {
      //If back button is clicked then it will send by the Serial Port a 4 to be interpreted by the Arduino
      myPort.write('4');
      
      AudioPlayer newPlayer = minim.loadFile("starfleet-command-150605.mp3"); 
      // Reference: Pixabay. 2023. Main Title - Starfleet Command. [Online audio track]. Available: https://pixabay.com/music/main-title-starfleet-command-150605/
      changeSong(newPlayer);
    }
  }
}

/*
  Initialize and setup each view
*/
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
void changeSong(AudioPlayer newPlayer){
  // Stop the currently playing song
  if (player.isPlaying()) {
    player.pause();
    player.close();
  }
  player = newPlayer;
  player.play();
}
/* 
  initialize each image and font
*/
void setFontsAndImages() {
  
  //Using Star Jedi Font - Font source: FontSpace, [2019]. Star Jedi Font. [Online font]. Available: https://www.fontspace.com/star-jedi-font-f9641
  StarJedi = createFont("StarJediRounded-jW3R.ttf", starJediFontSize);
  
  //Using SF Distant Galaxy Font - Font source: FontSpace, [2019]. SF Distant Galaxy Font. [Online font]. Available: https://www.fontspace.com/sf-distant-galaxy-font-f6436
  DistantGalaxy = createFont("SF Distant Galaxy Outline.ttf", distantGalaxyFontSize);
  
  // Using Death Star Font - Font source: FontSpace, [2016]. Death Star Font. [Online font]. Available: https://www.fontspace.com/death-star-font-f24305
  DeathStar = createFont("DeathStar-VmWB.ttf", deathStarFontSize);
  
  //Using Mandalorian Font - Font source: DaFont, [2005]. Mandalorian Font. [Online font]. Available: https://www.dafont.com/mandalorian.font
  Mandalorian = createFont("mandalor.ttf", mandalorianFontSize);
  
  
  /*
    grogu1.png - Image source: Pinterest, [2023]. Grogu 1. [Online image]. Available: https://co.pinterest.com/pin/16888567358962658/
    Adapted from: https://co.pinterest.com/pin/16888567358962658/
  */
  Grogu = loadImage("grogu1.png");
  /*
    grogu_head.png - Image source: Pinterest, [2023]. Grogu Head. [Online image]. Available: https://co.pinterest.com/pin/16888567358962658/
    Adapted from: https://co.pinterest.com/pin/16888567358962658/
  */
  GroguHead = loadImage("grogu_head.png");
  /*
    mando.png - Image source: PNGIMG, [2023]. Mando. [Online image]. Available: https://pngimg.com/image/109502
    Adapted from: https://pngimg.com/image/109502
  */
  MandoHead = loadImage("mando.png");
  /*
    darktrooper.png - Image source: Custom Cursor, [2023]. Star Wars Dark Trooper Blaster Rifle. [Online image]. Available: https://custom-cursor.com/es/collection/star-wars/sw-dark-trooper-blaster-rifle
    Adapted from: https://custom-cursor.com/es/collection/star-wars/sw-dark-trooper-blaster-rifle
  */
  DarkTrooperHead = loadImage("darktrooper.png");
  /*
    EmojiBlitzMoffGideon-PowerUp.png - Image source: Disney Emoji Blitz Fandom, [2023]. Moff Gideon. [Online image]. Available: https://disneyemojiblitz.fandom.com/wiki/Moff_Gideon
    Adapted from: https://disneyemojiblitz.fandom.com/wiki/Moff_Gideon
  */
  MoffGideonHead = loadImage("EmojiBlitzMoffGideon-PowerUp.png");
  /*
    TIE.png - Image source: Pinterest, [2013]. TIE. [Online image]. Available: https://co.pinterest.com/pin/AX4vTu9t99njrthFHGBMoL2bBqg5RVmEbDhwt2aD5p68LRbyvZp7y00/
    Adapted from: https://co.pinterest.com/pin/AX4vTu9t99njrthFHGBMoL2bBqg5RVmEbDhwt2aD5p68LRbyvZp7y00/
  */
  TIE = loadImage("TIE.png");
  /*
    trooper.png - Image source: Pinterest, [2023]. Trooper. [Online image]. Available: https://www.pinterest.com.mx/pin/67342956920364569/
    Adapted from: https://www.pinterest.com.mx/pin/67342956920364569/
  */
  TrooperHead = loadImage("trooper.png");
}

/*
  Fill array level by parsing the string value received by the Serial port into int
*/
void fillArrayLevel(String[] values) {
  for (int i = 0; i < values.length; i++) {
    arrayLevel[i] = int(values[i]);
  }
}

/*
  Set default values as array of 0s and 0 score to the level passed in the params
*/
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



/*

  References:
  
  Pinterest, [2023]. Carrogrugu. [Online image]. Available: https://www.pinterest.co.uk/pin/7036943159608445/
  
  Custom Cursor, [2023]. Star Wars Dark Trooper Blaster Rifle. [Online image]. Available: https://custom-cursor.com/es/collection/star-wars/sw-dark-trooper-blaster-rifle
  
  Disney Emoji Blitz Fandom, [2023]. Moff Gideon. [Online image]. Available: https://disneyemojiblitz.fandom.com/wiki/Moff_Gideon

  Pinterest, [2023]. Grogu Head. [Online image]. Available: https://co.pinterest.com/pin/16888567358962658/
  
  Pinterest, [2023]. Grogu 1. [Online image]. Available: https://co.pinterest.com/pin/16888567358962658/

  PNGIMG, [2023]. Mando. [Online image]. Available: https://pngimg.com/image/109502
  
  Pinterest, [2019]. Mando and Grogu. [Online image]. Available: https://www.pinterest.es/pin/818951513476811095/?amp_client_id=CLIENT_ID%28_%29&mweb_unauth_id=&amp_url=https%3A%2F%2Fwww.pinterest.es%2Famp%2Fpin%2F818951513476811095%2F&amp_expand=true

  Pinterest, [2013]. TIE. [Online image]. Available: https://co.pinterest.com/pin/AX4vTu9t99njrthFHGBMoL2bBqg5RVmEbDhwt2aD5p68LRbyvZp7y00/

  Pinterest, [2023]. Trooper. [Online image]. Available: https://www.pinterest.com.mx/pin/67342956920364569/
  
  FontSpace, [2016]. Death Star Font. [Online font]. Available: https://www.fontspace.com/death-star-font-f24305

  DaFont, [2005]. Mandalorian Font. [Online font]. Available: https://www.dafont.com/mandalorian.font

  FontSpace, [2019]. SF Distant Galaxy Font. [Online font]. Available: https://www.fontspace.com/sf-distant-galaxy-font-f6436

  FontSpace, [2019]. Star Jedi Font. [Online font]. Available: https://www.fontspace.com/star-jedi-font-f9641
  
  Pixabay. 2023. Main Title - Starfleet Command. [Online audio track]. Available: https://pixabay.com/music/main-title-starfleet-command-150605/
  
  Pixabay. 2023. Main Title - Cinematic Battle Music (Star Wars Style). [Online audio track]. Available: https://pixabay.com/music/main-title-cinematic-battle-music-star-wars-style-148641/

  Pixabay. 2023. Main Title - Space Adventures (Orchestral Music, Star Wars Style). [Online audio track]. Available: https://pixabay.com/music/main-title-space-adventures-orchestral-music-star-wars-style-139660/

*/
