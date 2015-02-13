import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import processing.serial.*;

// window specific constants and variables
int window = 600; // radar window width and height in pixels
int border = 60; // outer border of radar circle in pixels

float topAngle = 0; // top angle for radar highlighted strip
float botAngle = QUARTER_PI; // bottom angle for radar highlighted slip
float middle = window / 2; // center pixel of window
float boundary = window - border; // edge of working radar circle
float angle; // holds angle around the circle of current sensor direction

PImage bgImage;

// serial monitor objects and variables
Serial myPort; // The serial port object

float sensorValue = 2.5; // distance from Arduino - initialized to 2.5cm as "zero" as first reading
float sensorAngle = 0; // angle from Arduino - initizlied to zero for first reading

// Twitter objects and variables
String message; // holds message to be displayed in twitter message upon request
Twitter twitter; // twitter object

// make sure you use / not \ for file names
File twitFile = new File ("C:/Users/Theresa_Win/Documents/GitHub/EECE-281-Lab-5/Processing/lab5/data/twitterImage.png");

void setup() {
  size(window, window);
  
  twitterSetup();
  serialSetup(0); // pass in the port you need; typically 0.
  
  bgImage = loadImage("radar.jpg");
}

void draw() {
  background(bgImage);
  automaticRadar(false); // toggle for radar by touch/click or rolling radar
  
  // draws black center circle
  fill(0);
  ellipseMode(CENTER);
  ellipse(middle - 1, middle - 1, 50, 50); // centre circle to mask radar slice that will draw down to a point if we let it.
  
  plotDataLine(); // plots current data reading from serial monitor
}

void mousePressed() {
  redraw(); // calls draw function
}

void serialEvent (Serial myPort) {
  String serialRead = myPort.readStringUntil('\n'); // "cm degrees"
  serialRead = trim(serialRead); // trim trailing and leading whitespace
  
  sensorValue = float(serialRead.split(" ")[0]); // distance to plot on radar (cm)
  sensorAngle = float(serialRead.split(" ")[1]); // angle to plot on radar (degree) where zero degrees is facing foreward
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    saveFrame("data/twitterImage.png"); // screenshot of current radar
    
    if (sensorValue < 5) message = "Don't come any closer or I'll cast a spell on you!";
    else if (sensorValue < 20) message = "Hey, you're kinda in my personal space.\nYou are " + sensorValue + " cm from my sensor.";
    else message = "Hi there, hows it going?\nYou are " + sensorValue + " cm from my sensor.";
    
    tweet(message);
  }
}

void twitterSetup() {
  ConfigurationBuilder cb = new ConfigurationBuilder();

  //Twitter Credentials - initializing configuration builder
  cb.setOAuthConsumerKey(API_Constants.API_KEY);
  cb.setOAuthConsumerSecret(API_Constants.API_SECRET);
  cb.setOAuthAccessToken(API_Constants.ACCESS_TOKEN);
  cb.setOAuthAccessTokenSecret(API_Constants.ACCESS_SECRET);

  // factory class - object for creating other objects
  TwitterFactory tf = new TwitterFactory(cb.build()); // Twitter factory
  twitter = tf.getInstance(); // initialize a twitter object
}

// serialMonitor exists so Steven can quickly switch ports as his laptop is special and needs extra attention
void serialSetup(int port) {
  println(Serial.list()); // List available serial ports in monitor for reference
  myPort = new Serial(this, Serial.list()[port], 115200); // open serial port - tested laptop only uses one
  myPort.bufferUntil('\n');  // don't generate a serialEvent() unless you get a newline character
}

void automaticRadar(boolean auto) {
  if (auto) {  // move forward every 0.01 every frame
    topAngle += 0.01;
    botAngle += 0.01;
  } else { // changes based on reading from serial monitor
    angle = ((sensorAngle * PI) / 180) - PI/2; // sensor angle in radians
    topAngle = angle - PI / 8;
    botAngle = angle + PI / 8;
  }
  
  fill(50, 100, 50, 100); // 4th value is alpha channel (transparency)
  
  noStroke(); // removes border around arc
  
  arc(middle, middle, boundary, boundary, topAngle, botAngle); // finally we draw the radar slice
}

void plotDataLine() {
  strokeWeight(3);
  strokeCap(SQUARE);
  stroke(0, 255, 0, 200);
  
  float sensorPlot; // sensor distance reading scaled to fit in window
  
  if (sensorValue > 250) sensorPlot = boundary;
  else if (sensorValue > 50) sensorPlot = map(sensorValue, 50, 250, 175, boundary);
  else sensorPlot = map(sensorValue, 2.5, 50, 60, 175);
  
  println(sensorValue + " " + sensorAngle);
  
  noFill(); // creates arc as a stroke only
  
  arc(middle, middle, sensorPlot, sensorPlot, topAngle, botAngle); // radar plot
}

void tweet (String message) {
  try {
    StatusUpdate status = new StatusUpdate(message);
    status.setMedia(twitFile);
    twitter.updateStatus(status);

    System.out.println("Status updated to: " + message); // leave this here
  } 
  catch (TwitterException te) { 
    System.out.println("Error: " + te.getMessage());
  }
}

