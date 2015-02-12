import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import processing.serial.*;

int window = 600;
int border = 60;
float topAngle = 0;
float botAngle = QUARTER_PI;
float middle = window / 2;
float boundry = window - border;
float angle;
float sensorValue;
String message;
Twitter twitter;
PImage bgImage;
Serial myPort; // The serial port object
File file = new File(sketchPath("twitterImage.png")); // path of screenshot image

void setup() {
  size(window, window);
  twitterSetup();
  serialSetup(0); // pass in the port you need; typically 0.
  bgImage = loadImage("radar.jpg");
}

void draw() {
  background(bgImage);
  automaticRadar(false); // toggle for radar by touch/click or rolling radar
  fill(0);
  ellipseMode(CENTER);
  ellipse(middle - 1, middle - 1, 50, 50); // centre circle to mask radar slice that will draw down to a point if we let it.
  plotDataLine();
}

void mousePressed() {
  redraw();
}

void automaticRadar(boolean auto) {
  if (auto) {
    topAngle += 0.01; // move forward every 0.05 every frame
    botAngle += 0.01;
  } else {
    angle = atan2(mouseY - height / 2, mouseX - width / 2); // shape follows mouse or touch drag
    topAngle = angle - PI / 8;
    botAngle = angle + PI / 8;
  }
  fill(50, 100, 50, 100); // 4th value is alpha channel (transparency)
  noStroke();
  arc(middle, middle, boundry, boundry, topAngle, botAngle); // finally we draw the radar slice
}

void plotDataLine() {
  strokeWeight(3);
  strokeCap(SQUARE);
  stroke(0, 255, 0, 200);
  if (sensorValue > 250) // Maximum value coming from the serial monitor is 300; it's set that high so we get boundry cases.
    sensorValue = 250;
  float sensorPlot = map(sensorValue, 2.5, 250, 0, boundry); // possible mapping issue here
  noFill();
  arc(middle, middle, sensorPlot, sensorPlot, topAngle, botAngle); // radar plot
}

void twitterSetup() {
  ConfigurationBuilder cb = new ConfigurationBuilder();

  //Twitter Credentials
  cb.setOAuthConsumerKey(API_Constants.API_KEY);
  cb.setOAuthConsumerSecret(API_Constants.API_SECRET);
  cb.setOAuthAccessToken(API_Constants.ACCESS_TOKEN);
  cb.setOAuthAccessTokenSecret(API_Constants.ACCESS_SECRET);

  TwitterFactory tf = new TwitterFactory(cb.build()); // Twitter factory
  twitter = tf.getInstance(); // initialize twitter object
}

// serialMonitor exists so Steven can quickly switch ports as his laptop is special and needs extra attention
void serialSetup(int port) {
  println(Serial.list()); // List available serial ports in monitor for reference
  myPort = new Serial(this, Serial.list()[port], 115200); // open serial port - tested laptop only uses one
  myPort.bufferUntil('\n');  // don't generate a serialEvent() unless you get a newline character
}

void serialEvent (Serial myPort) {
  String serialRead = myPort.readStringUntil('\n');
  serialRead = trim(serialRead); // trim trailing and leading whitespace
  println(serialRead);
  sensorValue = float(serialRead);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    if (sensorValue < 5) message = "Don't come any closer or I'll cast a spell on you!";
    else if (sensorValue < 20) message = "Hey, you're kinda in my personal space.\nYou are " + sensorValue + " cm from my sensor.";
    else message += "Hi there, hows it going?\nYou are " + sensorValue + " cm from my sensor.";
    tweet(message);
  }
}

void tweet (String message) {
  try {
    Status status = twitter.updateStatus(message); // update our status with a text
    System.out.println("Status updated to: " + message); // leave this here
  } 
  catch (TwitterException te) { 
    System.out.println("Error: " + te.getMessage());
  }
}

