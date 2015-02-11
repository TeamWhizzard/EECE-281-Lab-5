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

#include <LiquidCrystal.h>
#include "Ultrasonic.h"

// pin declaration
LiquidCrystal lcd(2, 3, 8, 9, 10, 11); // initialize LCD display object
Ultrasonic ultrasonic(6,5); // initialize Ultrasonic sensor object (trigger, echo)

void setup() {
  Serial.begin(115200); // serial Port Initialization
  lcd.begin(16, 2); // initialize LCD display
}

void loop() {
  lcd.setCursor(1, 2);
  lcd.print(ultrasonic.Ranging(CM));
  delay(1000);
}

// introductory LCD messages
void serial_lcd_intro (void) {
  lcd.setCursor(0, 0);
  lcd.print(F(" Team Whizzard  ")); // first 16 characters of message
  lcd.setCursor(0, 1);
  lcd.print(F("   presents:    ")); // remaining characters of message
  delay(1000);
  lcd.clear();

  lcd.setCursor(0, 0);
  lcd.print(F(" Cautious Bird! "));
  delay(1000);
  lcd.clear();
  
  lcd.setCursor (0, 0);
  lcd.print(F("  Temp   Range  "));
}
