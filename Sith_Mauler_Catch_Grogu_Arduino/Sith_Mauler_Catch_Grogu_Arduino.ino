//int pinsArduinoInputs[] = { 0, 12, 2, 3, 4, 5 };
//int pinsArduinoOutputs[] = { 6, 7, 8, 9, 10, 11 };
//int arduinoUnoSize = 6;
int pinsArduinoInputs[] = { 2, 7 };
int pinsArduinoOutputs[] = { 8, 9 };
int arduinoUnoSize = 2;


bool isLevel1;
bool isLevel2;
bool isLevel3;


int pressed1 = 0;
int pressed2 = 0;
int pressed3 = 0; 

char code;

void setup() {
  // put your setup code here, to run once:
  setInputsAndOutputsMode(pinsArduinoInputs, pinsArduinoOutputs, arduinoUnoSize);
  Serial.begin(9600);
  isLevel1 = false;
  isLevel2 = false;
  isLevel3 = false;
  pressed1 = 0;
  pressed2 = 0;
  pressed3 = 0; 
}

void loop() {
  // put your main code here, to run repeatedly: 
  if (Serial.available()) {
    code = Serial.read();
    if (code == '1') {
      isLevel1 = true;
      isLevel2 = false;
      isLevel3 = false;
    }
    if (code == '2') {
      isLevel2 = true;
      isLevel1 = false;
      isLevel3 = false;
    }
    if (code == '3') {
      /*isLevel3 = true;
      isLevel1 = false;
      isLevel2 = false;*/ 
    }
    if (code == '4') {
      isLevel1 = false;
      isLevel2 = false;
      isLevel3 = false;
      pressed1 = 0;
      pressed2 = 0;
      pressed3 = 0; 
    }
  }
  if (isLevel1) {
    playLevel1(arduinoUnoSize, pinsArduinoInputs, pinsArduinoOutputs);
  }
  if (isLevel2) {
    playLevel2(arduinoUnoSize, pinsArduinoInputs, pinsArduinoOutputs);
  }
  if (isLevel3) {
    /*playLevel3(arduinoUnoSize, pinsArduinoInputs, pinsArduinoOutputs);*/
  }
}

void setInputsAndOutputsMode(int pinsInput[], int pinsOutput[], int size) {
  for (int i = 0; i < size; i++) {
    pinMode(pinsInput[i], INPUT);
    pinMode(pinsOutput[i], OUTPUT);
  }
}


void playLevel1(int sizeOfPins, int pinsInput[], int pinsOutput[]) {
  int randomValue1 = random(0, sizeOfPins);
  digitalWrite(pinsOutput[randomValue1], HIGH);
  unsigned long startTime = millis(); 
  pressed1 = LOW;
  unsigned long debounceDelay = 100;
  while (millis() - startTime < 1000) {
    pressed1 = digitalRead(pinsInput[randomValue1]);
    if (pressed1 == HIGH && millis() - startTime >= debounceDelay) {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      matrix[randomValue1] = 3;
      digitalWrite(pinsOutput[randomValue1], LOW);
     	Serial.print("P:");
      sendArray(matrix);
      break;
    } else {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 1, randomValue1, matrix);
      sendArray(matrix);
    }
  }  
  digitalWrite(pinsOutput[randomValue1], LOW);
  delay(100);
}

void playLevel2(int sizeOfPins, int pinsInput[], int pinsOutput[]) {
  int randomValue1 = random(0, sizeOfPins);
  int randomValue2;
  do {
    randomValue2 = random(0, sizeOfPins);
  } while (randomValue2 == randomValue1);
  digitalWrite(pinsOutput[randomValue1], HIGH);
  digitalWrite(pinsOutput[randomValue2], HIGH);
  unsigned long startTime = millis(); 
  pressed1 = LOW;
  pressed2 = LOW;
  unsigned long debounceDelay = 100; 
  while (millis() - startTime < 1000) {
    pressed1 = digitalRead(pinsInput[randomValue1]);
    pressed2 = digitalRead(pinsInput[randomValue2]);
    if (pressed1 == HIGH && pressed2 == HIGH && millis() - startTime >= debounceDelay) {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      matrix[randomValue1] = 3;
      matrix[randomValue2] = 3;
      Serial.print("P:");
      sendArray(matrix);
      digitalWrite(pinsOutput[randomValue1], LOW);
      digitalWrite(pinsOutput[randomValue2], LOW);
      break;
    } else {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 2, randomValue1, randomValue2, matrix);
      sendArray(matrix);
    }
  }  
  digitalWrite(pinsOutput[randomValue1], LOW);
  digitalWrite(pinsOutput[randomValue2], LOW);  
  delay(100);
}

void playLevel3(int sizeOfPins, int pinsInput[], int pinsOutput[]) {
  int randomValue1 = random(0, sizeOfPins);
  int randomValue2;
  do {
    randomValue2 = random(0, sizeOfPins);
  } while (randomValue2 == randomValue1);
  int randomValue3;
  do {
    randomValue3 = random(0, sizeOfPins);
  } while (randomValue3 == randomValue1 || randomValue3 == randomValue2);

  digitalWrite(pinsOutput[randomValue1], HIGH);
  digitalWrite(pinsOutput[randomValue2], HIGH);
  digitalWrite(pinsOutput[randomValue3], HIGH);
  unsigned long startTime = millis();
  pressed1 = LOW;
  pressed2 = LOW;
  pressed3 = LOW; 
  unsigned long debounceDelay = 100;
  while (millis() - startTime < 1000) {
    pressed1 = digitalRead(pinsInput[randomValue1]);
    pressed2 = digitalRead(pinsInput[randomValue2]);
    pressed3 = digitalRead(pinsInput[randomValue3]);
    if (pressed1 == HIGH && pressed2 == HIGH && pressed3 == HIGH && millis() - startTime >= debounceDelay) {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      matrix[randomValue1] = 3;
      matrix[randomValue2] = 3;
      matrix[randomValue3] = 3;      
      Serial.print("P:");
      sendArray(matrix);
      digitalWrite(pinsOutput[randomValue1], LOW);
      digitalWrite(pinsOutput[randomValue2], LOW);
      digitalWrite(pinsOutput[randomValue3], LOW);
      break;
    } else {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 3, randomValue1, randomValue2, randomValue3, matrix);
      sendArray(matrix);
    }
  }  
  digitalWrite(pinsOutput[randomValue1], LOW);
  digitalWrite(pinsOutput[randomValue2], LOW);
  digitalWrite(pinsOutput[randomValue3], LOW);
  delay(100);
}

void sendArray(int* myArray){
  for (int i = 0; i < 9; i++) {
    Serial.print(myArray[i]);
    if (i < 9 - 1) {
      Serial.print(","); 
    }
  }
  Serial.println();
}

void readButtons(int sizeOfPins, int pinsInput[], int levelMaxCounter, int random1, int* matrix) {
  int counter = 0;
  matrix[random1] = 1;
  for (int i = 0; i < sizeOfPins; i++) {
    int pressed =  digitalRead(pinsInput[i]);
    if(pressed == HIGH) {
      matrix[i] = 2;
      counter++;
    }
    if(counter == levelMaxCounter){
      break;
    }
  }
}
void readButtons(int sizeOfPins, int pinsInput[], int levelMaxCounter, int random1, int random2, int* matrix) {
  int counter = 0;
  matrix[random1] = 1;
  matrix[random2] = 1;
  for (int i = 0; i < sizeOfPins; i++) {
    int pressed =  digitalRead(pinsInput[i]);
    if(pressed == HIGH) {
      matrix[i] = 2;
      counter++;
    }
    if(counter == levelMaxCounter){
      break;
    }
  }
}
void readButtons(int sizeOfPins, int pinsInput[], int levelMaxCounter, int random1, int random2, int random3, int* matrix) {
  int counter = 0;
  matrix[random1] = 1;
  matrix[random2] = 1;
  matrix[random3] = 1;
  for (int i = 0; i < sizeOfPins; i++) {
    int pressed =  digitalRead(pinsInput[i]);
    if(pressed == HIGH) {
      matrix[i] = 2;
      counter++;
    }
    if(counter == levelMaxCounter){
      break;
    }
  }
}