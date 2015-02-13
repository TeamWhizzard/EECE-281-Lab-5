import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

import processing.serial.*;

Serial myPort; // The serial port object

String lastSerRead = "70";
String message;
Twitter twitter;

// TODO - make it so file is the 

// file path of screenshot image
File file = new File(dataPath("twitterImage.png").replaceAll("\", "/"));
// make sure you use / not \ for file names
//File file = new File ("C:/Users/Theresa_Win/Desktop/twitterImage.png");
//File file = new File ("C:/Users/Theresa_Win/Documents/GitHub/EECE-281-Lab-5/Processing/processing_twitter");
//File file = new File ("data/twitterImage.png");
//PImage file = loadImage("data/twitterImage.png");
void setup()
{
    size(800,600);
    
    // Twitter authentication
    ConfigurationBuilder cb = new ConfigurationBuilder();
    
    cb.setOAuthConsumerKey(API_Constants.API_KEY);
    cb.setOAuthConsumerSecret(API_Constants.API_SECRET);
    cb.setOAuthAccessToken(API_Constants.ACCESS_TOKEN);
    cb.setOAuthAccessTokenSecret(API_Constants.ACCESS_SECRET);
    
    // Twitter factory
    TwitterFactory tf = new TwitterFactory(cb.build());
    twitter = tf.getInstance(); // initialize twitter object
    
    // Set up serial monitor connection
  // println(Serial.list()); // List available serial ports in monitor for reference
   //myPort = new Serial(this, Serial.list()[0], 115200); // open serial port - tested laptop only uses one
   //myPort.bufferUntil('\n');  // don't generate a serialEvent() unless you get a newline character   
}

void draw()
{
  // NOTE: THIS NEEDS TO BE HERE OR THINGS WONT WORK!
}

//void serialEvent (Serial myPort) {
//  lastSerRead = myPort.readStringUntil('\n');
//  lastSerRead = trim(lastSerRead); // trim trailing and leading whitespace
//}

void keyPressed()
{
  if (key == 't' || key == 'T') {
    println(dataPath("twitterImage.png").replaceAll("\", "/"));
    println(file.exists()); // test
    saveFrame("data/twitterImage.png");   
    println(file.exists()); // test
    
    if (int(lastSerRead) < 5) message = "Don't come any closer or I'll cast a spell on you!";
    else if (int(lastSerRead) < 20) message = "Hey, you're kindof in my personal space.\nYou are " + lastSerRead + " cm from my sensor.";
    else message = "Hi there, hows it going?\nYou are " + lastSerRead + " cm from my sensor.";

    tweet(message);
  }
}

void tweet (String message)
{
  try {
    // code that will be used for adding file
    StatusUpdate status = new StatusUpdate(message);
    status.setMedia(file);
    twitter.updateStatus(status);
    
    // code for working program
    //Status status = twitter.updateStatus(message);
    
    // leave this here   
    System.out.println("Status updated to: " + message);
  } catch (TwitterException te) { System.out.println("Error: " + te.getMessage()); }
}
