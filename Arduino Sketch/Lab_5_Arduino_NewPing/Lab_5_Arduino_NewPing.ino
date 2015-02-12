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

#include "NewPing.h"

const int pinTrig = 12;
const int pinEcho = 13;
const int pinTemp = A0;

const int MAX_DISTANCE = 300; // maximum reading distance of ultrasonic sensor in cm

float echoPulse;
float temperature;
float velocity;
float time;
float distance;

NewPing sonar(pinTrig, pinEcho, MAX_DISTANCE);

void setup() {
  Serial.begin(115200); // serial Port Initialization
}

void loop() {
  // speed of sound value is dependent on temperature
  // temperature holds current temperature in celcius
  // LN-35 outputs a reading in which 10mV is equivalent to 1 degree celcius
  // we convert this reading to Celsius by multiplying the input with the following constant:
  // 0.48828125 = total voltage source (V) / range of analogRead = (5 * 100) / 1024
  temperature = analogRead(pinTemp) * 0.48828125;
  echoPulse = float(sonar.ping_median()); // returns time to and from object
  
  if (echoPulse != 0) { // zero indicates no echo reading
  
    // distance = velocity * time where velocity is speed of sound
    velocity = (331.3 + (0.6 * temperature)); // speed of sound
    time = (echoPulse) / 2; // devide by two because functions returns twice the time needed
    distance = (velocity * time) / 10000; 
    Serial.println(distance);
    delay(1000);
  }
}
