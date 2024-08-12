
// 200 < 350 < 500
void setup() {
  
  // A3 as Ground sink pin
  pinMode(A3,OUTPUT);
  digitalWrite(A3, LOW);

  delay(1000);
  Serial.begin(9600);
//  while (Serial.available() <= 0) {

      Serial.println("0");
      delay(300);
//    }
}

void loop() {
 // if (Serial.available() > 0) {
    //inByte = Serial.read();

    Serial.print( analogRead(A1) );// A0:X |  A1:Y | A2:Z
    Serial.print('\n');
    delay(20);
 // }
}
