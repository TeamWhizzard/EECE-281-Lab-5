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

// pin declarations
const int pinTrig = 7;
const int pinEcho = 8;
const int pinTemp = A0;

const int directionPin = 2;
const int stepPin = 3;
const int sleepPin = 4;
const int resetPin = 5;
const int enablePin = 6;

const int MAX_DISTANCE = 300; // maximum reading distance of ultrasonic sensor in cm

float echoPulse; // time returned from ultrasonic sensor
float temperature; // temperature value in C

float velocity; // speed of sound to calculate distance(dependent on temperature)
float time; // time used in distance calculation
float distance; // calculated distance read by ultrasonic sensor

float angle = 0;
int directn = 1; // 1 is clockwise, -1 is counterclockwise

NewPing sonar(pinTrig, pinEcho, MAX_DISTANCE); // initialize ultrasonic sensor

void setup() {
  Serial.begin(115200); // serial Port Initialization
  
  pinMode(directionPin, OUTPUT);
  pinMode(stepPin, OUTPUT);
  pinMode(sleepPin, OUTPUT);
  pinMode(resetPin, OUTPUT);
  pinMode(enablePin, OUTPUT);  
  
  digitalWrite(directionPin, LOW);
  digitalWrite(stepPin, LOW);
  digitalWrite(sleepPin, HIGH);
  digitalWrite(resetPin, HIGH);
  digitalWrite(enablePin, LOW);
}

void loop() {
  // speed of sound value is dependent on temperature
  // temperature holds current temperature in celcius
  // LN-35 outputs a reading in which 10mV is equivalent to 1 degree celcius
  // we convert this reading to Celsius by multiplying the input with the following constant:
  // 0.48828125 = total voltage source (V) / range of analogRead = (5 * 100) / 1024
  temperature = analogRead(pinTemp) * 0.48828125;
  echoPulse = float(sonar.ping_median()); // returns time to and from object
  
  if (echoPulse != 0) { // zero indicates no echo reading - skips outputting to serial monitor
    // distance = velocity * time where velocity is speed of sound
    velocity = (331.3 + (0.6 * temperature)); // speed of sound
    time = (echoPulse) / 2; // devide by two because functions returns twice the time needed
    distance = (velocity * time) / 10000;
    
    steps(1, directn);
    angle = angle + 1.8 * directn;
    if(angle > 180) {
      directn = -1;
    }

    if(angle < -180) {
      directn = 1;
    }
  
    Serial.println(String(distance) + " " + String (angle));
    
    delay(200);
  }
}

// Moves the stepper motor a number of steps equal to argument
// positive for clockwise, negative for counterclockwise
void steps (int numsteps, int directn) {
  if (directn > 0) {
    digitalWrite(directionPin, LOW);
  } else {
    digitalWrite(directionPin, HIGH);
  }
  
  for(int i=0;i<abs(numsteps);i++) {
    digitalWrite(stepPin, HIGH);
    digitalWrite(stepPin, LOW);
  }
}
