 import processing.serial.*;
 
 static int lineHeight = 2; // hight of each spacing line in window
 static int rectWidth = 16; // number of pixels wide of each bar in the bar graph
 
 Serial myPort; // The serial port object
 
 // size paramaters, to be set dependent on declared window size
 int bargraph;
 int graphSep; // height of seperation between plots
 
 int xPos = 0;         // starting horizontal position of the graph
 
 void setup () {
   size(700, 500); // set the window size   
   bargraph = height;
   println(Serial.list()); // List available serial ports in monitor for reference
   myPort = new Serial(this, Serial.list()[1], 115200); // open serial port - tested laptop only uses one
   myPort.bufferUntil('\n');  // don't generate a serialEvent() unless you get a newline character
 }
 
 void draw () {
   // NOTE: THIS NEEDS TO BE HERE OR THINGS WONT WORK!
 }
 
 // serial events are called when new data is available
 // in this case it is detected by bufferUntil() in setup()
 void serialEvent (Serial myPort) {
   String serialReading = myPort.readStringUntil('\n'); // reads line from serial monitor
   serialReading = trim(serialReading); // trim trailing or leading whitespace
   float ultrasonic = Float.valueOf(serialReading).floatValue(); // converts string to a float
     
   // converts each float to a range that will fit in the specified window
   ultrasonic = norm(ultrasonic, 0, 100) * 100;

   // draw bars on graphs of data
   strokeWeight (1); // weight of black border around each bar
   strokeCap(SQUARE); // makes square line endings for bars

   fill(165, 6, 121); // set color purple
   rect(xPos, height - ultrasonic, rectWidth, ultrasonic); // draw rectangle

   if (xPos >= width) { // at edge of screen, go back to the beginning
     xPos = 0;   
 } else { // increment horizontal position for next reading
     xPos += rectWidth;
   }
 }
