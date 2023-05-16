class LightsaberTimeout {
  float timeoutDuration;
  float startTime;
  boolean timeoutReached;
  color lightsaberColor;

  LightsaberTimeout(float duration, color saberColor) {
    timeoutDuration = duration;
    startTime = millis();
    timeoutReached = false;
    lightsaberColor = saberColor;
  }

  void update() {
    float currentTime = millis();

    if (currentTime - startTime >= timeoutDuration) {
      timeoutReached = true;
    }
  }

  void drawLightsaber(float progress) {
    float h = 20;
    float gripWidth = 60;

    float gripX = width / 4;
    float gripY = height - height / 2.2;

    float bladeWidth = width / 1.8 - gripWidth - progress;
    float bladeX = gripX + gripWidth / 2;
    float bladeY = gripY - h / 2;

    rectMode(CORNER);
    strokeWeight(0);
    fill(lightsaberColor);
    rect(bladeX, bladeY, bladeWidth, h, 10);

    fill(100);
    noStroke();
    rectMode(CENTER);
    rect(gripX, gripY, gripWidth, h + 10, 10);
  }


  void drawTimeoutMessage() {
    fill(255);
    textFont(DeathStar);
    textSize(80);
    textAlign(CENTER, CENTER);
    text("Timeout reached!", width/2, height-height/2.2);
  }

  boolean isTimeoutReached() {
    return timeoutReached;
  }
}
