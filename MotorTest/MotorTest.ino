const int directionPin = 2;
const int stepPin = 3;
const int sleepPin = 4;
const int resetPin = 5;
const int enablePin = 6;

void setup() {
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
  delay(100);
}

void loop() {
  digitalWrite(stepPin, HIGH);
  delay(10);
  digitalWrite(stepPin, LOW);
  delay(100);
}
