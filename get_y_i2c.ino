

//  MPU6050 3axix 3gyro  GY521module
#include <Wire.h>

#define MPU6050_ADDR 0x68
#define MPU6050_AX  0x3B
#define MPU6050_AY  0x3D
#define MPU6050_AZ  0x3F
#define MPU6050_TP  0x41    //  data not used
#define MPU6050_GX  0x43
#define MPU6050_GY  0x45
#define MPU6050_GZ  0x47

short int AccX, AccY, AccZ;



void setup() {
  Serial.begin(19200);
  delay(100);
  Wire.begin();
  Wire.beginTransmission(MPU6050_ADDR);
  Wire.write(0x6B);
  Wire.write(0);
  Wire.endTransmission();
  delay(100);

}

void loop() {
  //  send start address
  Wire.beginTransmission(MPU6050_ADDR);
  Wire.write(MPU6050_AX);
  Wire.endTransmission();  
  //  Wire.requestFrom(MPU6050_ADDR, 14);
  Wire.requestFrom(MPU6050_ADDR, 6);
  //  get 6bytes
  AccX = Wire.read() << 8;  AccX |= Wire.read();
  AccY = Wire.read() << 8;  AccY |= Wire.read();
  //AccZ = Wire.read() << 8;  AccZ |= Wire.read();
  // get -15000 < 0 < 15000


  // map -15000 ~ 15000 to 200 ~ 500
  AccY = AccY/100 + 350; 
  Serial.print(AccY); 
  Serial.println("");
  delay(20);
 
}
