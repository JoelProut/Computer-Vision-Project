//Computer Vision Project v1.0
//...
//...

//Initialize
int hspeed = 0;
int outputPin = 7;
int interruptPin = 2;

//Define Pins and Interrupts
void setup() {
  // put your setup code here, to run once:
  pinMode(outputPin,OUTPUT);
  pinMode(interruptPin,INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPin),stop,CHANGE);
  
}

//Run...
void loop() {
  hspeed=100;
  // put your main code here, to run repeatedly:
  //analogWrite(motorOut,motorSpeed);
  analogWrite(outputPin,hspeed);
}
//Interrupt
void stop(){
  hspeed=0;
  analogWrite(outputPin,hspeed);
  }
