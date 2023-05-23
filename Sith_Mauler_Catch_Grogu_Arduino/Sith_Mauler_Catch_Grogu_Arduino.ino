/*
  Initialize the pins inputs and pins outputs as arrays, as well as the size of both arrays.
*/

int pinsArduinoInputs[] = { 5, 6, 7, 8, 9, 10, 11, 12, 13 };
int pinsArduinoOutputs[] = { 2, 3, 4, A0, A1, A2, A3, A4, A5};
int arduinoUnoSize = 9;

/*
  Declare the bool variables of level states. 
*/
bool isLevel1;
bool isLevel2;
bool isLevel3;

/*
  Declare the int variables of the possible inputs to be pressed in the each "round" of the level.
*/
int pressed1 = 0;
int pressed2 = 0;
int pressed3 = 0; 

// Declare the char variable that would be the code received from Processing.
char code;

void setup() {
  // Set default values to each variable and set Serial communication. 
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
  /* Each time the loops iterates if any data in the Serial port is available to be read it will read it and interpretate some chars.
    If the code is '1' it means that the level 1 should be set as true and the others as false.
    If the code is '2' it means that the level 2 should be set as true and the others as false.
    If the code is '3' it means that the level 3 should be set as true and the others as false.
    If the code is '4' it means that all the levels should be set as false.
  */
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
      isLevel3 = true;
      isLevel1 = false;
      isLevel2 = false;
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
  //If any level is true it will play a round of the corresponding level.
  if (isLevel1) {
    playLevel1(arduinoUnoSize, pinsArduinoInputs, pinsArduinoOutputs);
  }
  if (isLevel2) {
    playLevel2(arduinoUnoSize, pinsArduinoInputs, pinsArduinoOutputs);
  }
  if (isLevel3) {
    playLevel3(arduinoUnoSize, pinsArduinoInputs, pinsArduinoOutputs);
  }
}

//Set the mode of each pin as input or output.
void setInputsAndOutputsMode(int pinsInput[], int pinsOutput[], int size) {
  for (int i = 0; i < size; i++) {
    pinMode(pinsInput[i], INPUT);
    pinMode(pinsOutput[i], OUTPUT);
  }
}

/*
  This would be a representation of each "round" of the level.
  The params to be provided are: int sizeOfPins, int pinsInput[], int pinsOutput[].
  At first, it provides 1 random value from 0 to sizeOfPins representing the index of both arrays.
  Set the random index output as HIGH and start the waiting time at 1000 millis to read if the user pressed the random input index value selected.
  There are 4 possible representing values for the array :
    - 0: If the user does not press that input index and the random value index is different 
    - 1: If the user does not press that input index and the random value index is equal.
    - 2: If the user press that input index and the random value index is different 
    - 3: If the user press that input index and the random value index is equal 
  In each millis that passed, it validates:
    - If the user pressed the wrong expected input
    - If the user pressed the expected input
  In each validation it sends the array with the representing values of the array, but if the user press the random index value (case 3) 
    adds a "P:" representing that the user wins a point and sets as LOW the random index output. 
*/
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
/*
  This would be a representation of each "round" of the level.
  The params to be provided are: int sizeOfPins, int pinsInput[], int pinsOutput[].
  At first, it provides 2 random values from 0 to sizeOfPins representing the index of both arrays.
  Set the random indeces output as HIGH and start the waiting time at 1000 millis to read if the user pressed the randoms inputs indeces values selected.
  There are 4 possible representing values for the array :
    - 0: If the user does not press that input index and the random value index is different 
    - 1: If the user does not press that input index and the random value index is equal.
    - 2: If the user press that input index and the random value index is different 
    - 3: If the user press that input index and the random value index is equal 
  In each millis that passed, it validates:
    - If the user pressed the wrong expected inputs
    - If the user pressed one of the expected inputs
    - If the user pressed both of the expected inputs
  In each validation it sends the array with the representing values of the array, 
  but if the user press the both random indeces values (case 3) adds a "P:" representing that the user wins a point and sets as LOW the random indeces outputs. 
*/
void playLevel2(int sizeOfPins, int pinsInput[], int pinsOutput[]) {
  int randomValue1 = random(0, sizeOfPins);
  int randomValue2;
  do {
    randomValue2 = random(0, sizeOfPins);
  } while (randomValue2 == randomValue1);
  digitalWrite(pinsOutput[randomValue1], HIGH);
  digitalWrite(pinsOutput[randomValue2], HIGH);
  int pressed1Counter = 0;   
  int pressed2Counter = 0;   
  unsigned long startTime = millis(); 
  pressed1 = LOW;
  pressed2 = LOW;
  unsigned long debounceDelay = 100; 
  while (millis() - startTime < 1000) {
    pressed1 = digitalRead(pinsInput[randomValue1]);
    pressed2 = digitalRead(pinsInput[randomValue2]);
    if (pressed1 == HIGH && millis() - startTime >= debounceDelay ) {
      pressed1Counter++;
      digitalWrite(pinsOutput[randomValue1], LOW);
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 2, randomValue1, randomValue2, matrix);
      matrix[randomValue1] = 3;
      sendArray(matrix);
    }
    if (pressed2 == HIGH && millis() - startTime >= debounceDelay ) {
      pressed2Counter++;
      digitalWrite(pinsOutput[randomValue2], LOW);
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 2, randomValue1, randomValue2, matrix);
      matrix[randomValue2] = 3;
      sendArray(matrix);
    }
    if (pressed1Counter == 1 && pressed2Counter == 1) {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      matrix[randomValue1] = 3;
      matrix[randomValue2] = 3;
      Serial.print("P:");
      sendArray(matrix);
      break;
    } else {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 2, randomValue1, randomValue2, matrix);
      if(pressed1Counter == 1) {
        matrix[randomValue1] = 3;        
      }
      if(pressed2Counter == 1) {
        matrix[randomValue2] = 3;        
      }
      sendArray(matrix);
    }
  }  
  digitalWrite(pinsOutput[randomValue1], LOW);
  digitalWrite(pinsOutput[randomValue2], LOW);  
  delay(100);
}
/*
  This would be a representation of each "round" of the level.
  The params to be provided are: int sizeOfPins, int pinsInput[], int pinsOutput[].
  At first, it provides 3random values from 0 to sizeOfPins representing the index of both arrays.
  Set the random indeces output as HIGH and start the waiting time at 1000 millis to read if the user pressed the randoms inputs indeces values selected.
  There are 4 possible representing values for the array :
    - 0: If the user does not press that input index and the random value index is different 
    - 1: If the user does not press that input index and the random value index is equal.
    - 2: If the user press that input index and the random value index is different 
    - 3: If the user press that input index and the random value index is equal 
  In each millis that passed, it validates:
    - If the user pressed the wrong expected inputs
    - If the user pressed one of the expected inputs
    - If the user pressed two of the expected inputs
    - If the user pressed the 3 expected inputs
  In each validation it sends the array with the representing values of the array, 
  but if the user press the 3 random indeces values (case 3) adds a "P:" representing that the user wins a point and sets as LOW the random indeces outputs. 
*/
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
  int pressed1Counter = 0;   
  int pressed2Counter = 0;
  int pressed3Counter = 0;
  unsigned long startTime = millis();
  pressed1 = LOW;
  pressed2 = LOW;
  pressed3 = LOW; 
  unsigned long debounceDelay = 100;
  while (millis() - startTime < 1000) {
    pressed1 = digitalRead(pinsInput[randomValue1]);
    pressed2 = digitalRead(pinsInput[randomValue2]);
    pressed3 = digitalRead(pinsInput[randomValue3]);
    if (pressed1 == HIGH && millis() - startTime >= debounceDelay ) {
      pressed1Counter++;
      digitalWrite(pinsOutput[randomValue1], LOW);
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 3, randomValue1, randomValue2, randomValue3, matrix);
      matrix[randomValue1] = 3;
      sendArray(matrix);
    }
    if (pressed2 == HIGH && millis() - startTime >= debounceDelay ) {
      pressed2Counter++;
      digitalWrite(pinsOutput[randomValue2], LOW);
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 3, randomValue1, randomValue2, randomValue3, matrix);
      matrix[randomValue2] = 3;
      sendArray(matrix);
    }
    if (pressed3 == HIGH && millis() - startTime >= debounceDelay ) {
      pressed3Counter++;
      digitalWrite(pinsOutput[randomValue3], LOW);
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 3, randomValue1, randomValue2, randomValue3, matrix);
      matrix[randomValue3] = 3;
      sendArray(matrix);
    }
    if (pressed1Counter == 1 && pressed2Counter == 1 && pressed3Counter == 1) {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      matrix[randomValue1] = 3;
      matrix[randomValue2] = 3;
      matrix[randomValue3] = 3;      
      Serial.print("P:");
      sendArray(matrix);
      break;
    } else {
      int matrix[] = {0,0,0,0,0,0,0,0,0};
      readButtons(sizeOfPins, pinsInput, 3, randomValue1, randomValue2, randomValue3, matrix);
      if(pressed1Counter == 1) {
        matrix[randomValue1] = 3;        
      }
      if(pressed2Counter == 1) {
        matrix[randomValue2] = 3;        
      }
      if(pressed3Counter == 1) {
        matrix[randomValue3] = 3;        
      }
      sendArray(matrix);
    }
  }  
  digitalWrite(pinsOutput[randomValue1], LOW);
  digitalWrite(pinsOutput[randomValue2], LOW);
  digitalWrite(pinsOutput[randomValue3], LOW);
  delay(100);
}

/*
  It parse the int array of values into a concatenate array and send it in the Serial port
*/
void sendArray(int* myArray){
  for (int i = 0; i < 9; i++) {
    Serial.print(myArray[i]);
    if (i < 9 - 1) {
      Serial.print(","); 
    }
  }
  Serial.println();
}
/*
  This method override fills the level array with representing values.
  Sets the random(s) index (ces) with '1' and if any input (except from the expected one(s) ) is pressed it sets it as '2'

*/
void readButtons(int sizeOfPins, int pinsInput[], int levelMaxCounter, int random1, int* matrix) {
  int counter = 0;
  matrix[random1] = 1;
  for (int i = 0; i < sizeOfPins; i++) {
    int pressed =  digitalRead(pinsInput[i]);
    if(pressed == HIGH) {
      matrix[i] = 2;
      counter++;
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
  }
}