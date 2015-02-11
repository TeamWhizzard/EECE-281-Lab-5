/* EECE 281
 * Lab 5
 *
 *      Team Whizzard is...
 *                           .
 *               /^\     .
 *          /\   "V"
 *         /__\   I      L  .           John Deppe
 *        //..\\  I        a               Theresa Mammarella
 *        \].`[/  I       b                   Steven Olsen
 *       /l\/j\  (]    .   5
 *       /. ~~ ,\/I          .
 *       \\L__j^\/I       o
 *        \/--v}  I     o   .
 *        |    |  I   _________
 *        |    |  I c(`       ')o
 *        |    l  I   \.     ,/
 *       _/j  L l\_!  _//^---^\\_
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

//#include <LiquidCrystal.h>
#include "NewPing.h"

const int pinTrig = 8;
const int pinEcho = 9;
const int pinTemp = A1;

const int MAX_DISTANCE = 500; // maximum reading distance of ultrasonic sensor in cm

float echoPulse;
float temperature;
float velocity;
float time;
float distance;

// pin declaration
//LiquidCrystal lcd(2, 3, 8, 9, 10, 11); // initialize LCD display object
NewPing sonar(pinTrig, pinEcho, MAX_DISTANCE);

void setup() {
  Serial.begin(115200); // serial Port Initialization
  //lcd.begin(16, 2); // initialize LCD display

  //serial_lcd_intro();
}

void loop() {
  // speed of sound value is dependent on temperature
  // temperature holds current temperature in celcius
  // LN-35 outputs a reading in which 10mV is equivalent to 1 degree celcius
  // we convert this reading to Celsius by multiplying the input with the following constant:
  // 0.48828125 = total voltage source (V) / range of analogRead = (5 * 100) / 1024
  temperature = analogRead(pinTemp) * 0.48828125;
  echoPulse = float(sonar.ping_median()); // returns time to and from object
  
  // distance = velocity * time where velocity is speed of sound
  velocity = (331.3 + (0.6 * temperature)); // speed of sound
  time = (echoPulse) / 2; // devide by two because functions returns twice the time needed
  distance = (velocity * time) / 10000; 
  
  //if (echoPu
  //distance = echoPulse / 58;
 // lcd.setCursor(1, 2);
  //lcd.print(distance);
  Serial.println(distance);
  delay(500);
}

// introductory LCD messages
//void serial_lcd_intro (void) {
//  lcd.setCursor(0, 0);
//  lcd.print(F(" Team Whizzard  ")); // first 16 characters of message
//  lcd.setCursor(0, 1);
//  lcd.print(F("   presents:    ")); // remaining characters of message
//  delay(1000);
//  lcd.clear();
//
//  lcd.setCursor(0, 0);
//  lcd.print(F(" Cautious Bird! "));
//  delay(1000);
//  lcd.clear();
//  
//  lcd.setCursor (0, 0);
//  lcd.print(F("  Temp   Range  "));
//}
