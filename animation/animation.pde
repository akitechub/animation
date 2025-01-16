/**
 processing-4
 arduino
 変更履歴
 2025-01-16 use_com =falseで mouseXによる動作確認
 data内ファイルの指定方法の変更
 
 
 get_y_****.ino に依存。
 使用する主な関数　map(), constrain(), image()
 **/

import processing.javafx.*;
import processing.serial.*;

boolean use_com = true;

/******************
 **
 ** 画像ファイル名
 **
 *****************/
String prefix = "loop";
int start     = 57600;
int end       = 57665;
String ext    = ".jpg";

// arduinoのシリアルポート番号 大抵0か1でしょう
int portNum = 1;

// winの人？　arduinoのシリアルポート名 大抵は COM3 ~ COM5
// コンソールに出力されるリストを見る。
String winPortName = "COM5";


// センサーの左右の取り付け方向
boolean Xdir = true;

// 《 C 必要なら調整 》
// 加速度センサーの上限値、下限値を設定( constrain()で使用）
int g_min = 130;
int g_max = 480;

// 《 D 必要なら調整 》
// アニメーションの向きとセンサーの動作が逆のときは 1 にする
int inv = 0;

// 《 E 要調整　センサーのオフセット　》
// 水平に静置時の増減のオフセット＝アニメが止まらない時に
int offset = -25;

//int slidenum_f = slidenum + 1;
int current = 0;

int del = 10;//delay

PImage Title;
int slidenum = end - start + 1;
PImage[] Slide = new PImage[slidenum];

Serial myPort; // シリアルポート

int input;
float current_a;



void setup() {
  size(720, 480, FX2D);
  if (use_com) {
    //String portName = Serial.list()[portNum];
    //String portName = Serial.list()[1];
    //String portName
    //String portName = 0;
    printArray(Serial.list());
    println( "portName= "+winPortName );
    myPort = new Serial(this, winPortName, 9600);

    // 改行コード(\n)が受信されるまで、シリアルメッセージを受けつづける
    myPort.bufferUntil('\n');
    delay( 1000 );
    myPort.write("A");
    delay( 1000 );
  }
  // 静止画ファイルを、全て読込む。
  for (int i = 0; i < slidenum; i++) {
    // loop56000.jpg
    Slide[i] = loadImage(prefix + (start + i) + ext );
    println( "loadImage -> " + prefix + (start + i) + ext);
  }
}






void draw() {
  background(0);

  //
  if (!use_com) 
    input = (mouseX+100)/10 + 300;
 
  float constrained = constrain( input + offset, g_min, g_max);
  float m = 0.0;

  if ( inv == 1) {
    m = map( constrained, g_max, g_min, g_min, g_max);
  } else {
    m = constrained;
  }

  int mapped = int(map( m, g_max, g_min, -20, 20 ));
  print("mapped-> "+mapped);
  if (  (m > 320) || (m < 290)) {

    current = current + mapped;
    print( " (0)sense = out");
  } else {
    if ( mapped == 1) {
      current ++;
      delay( del );
      print( " sense= ++");
    } else if ( mapped == -1 ) {
      current --;
      delay( del );
      print ( " sense= --");
    } else {
      current ++;
      delay( 150 );
      print( " sense= +-");
    }
  }
  // currentが静止画配列のsizeより多いときは…
  if ( current >= slidenum) {
    current = 0;
  }
  // currentが、0より少なくなってしまったときは…
  if ( current < 0 ) {
    current = slidenum-1;
  }


  // 「current番目」の画像を表示する
  println(" current-> " + current);
  image( Slide[current], 0, 0, width, height);
}




void serialEvent(Serial p) {
  String tmpString = p.readStringUntil('\n');

  // 空白文字などの"余計な情報を消去
  tmpString = trim(tmpString);
  input = int(tmpString);

  if ( !Xdir ) {
    input = int(map( input, 200, 460, 460, 200 )    );
  }
}
