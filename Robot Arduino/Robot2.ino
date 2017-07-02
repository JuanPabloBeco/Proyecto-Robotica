#include <SoftwareSerial.h>

#define ENABLE 4
#define RX_PIN 7
#define TX_PIN 8
#define BAUDRATE 9600

#define ENABLE_A 11
#define ENABLE_B 3
#define INPUT_1 10
#define INPUT_2 9  //Adelante si 1
#define INPUT_3 5   //Adelante si 1
#define INPUT_4 6

// set up a new serial object
SoftwareSerial BTSerial (RX_PIN, TX_PIN);
int i, a;
static String s;
static String r1;
static String r2;
static String r;
int in1, in2, m1, m2;
static char state = 0;

void setup() {
  pinMode(ENABLE, OUTPUT);
  pinMode(ENABLE_A,OUTPUT);
  pinMode(ENABLE_B,OUTPUT);
  pinMode(INPUT_1,OUTPUT);
  pinMode(INPUT_2,OUTPUT);
  pinMode(INPUT_3,OUTPUT);
  pinMode(INPUT_4,OUTPUT);
  digitalWrite(ENABLE, HIGH);
  digitalWrite(ENABLE_A,HIGH);
  digitalWrite(ENABLE_B,HIGH);
  analogWrite(INPUT_1,0);
  digitalWrite(INPUT_2,LOW);
  analogWrite(INPUT_3,0);
  digitalWrite(INPUT_4,LOW);
  Serial.begin(BAUDRATE);
  BTSerial.begin(BAUDRATE);  // HC-05 default speed in AT command more
}

void loop() {

  r = " ";
  r1 = " ";
  r2 = " ";
  s="";

  paquete();

}

void paquete()
{ 
   switch(state) 
   {
      case 0: //No esta llegado nada
        if (BTSerial.available())
        {
          state = 1;
        }
        break;
      case 1: //Mensaje esta llegando
        if (BTSerial.available())
        {
          state = 0;
          s = readBT();
          motores(s);
        }
      break;
   }
}  

void motores(String s)
{
  Serial.print(s);Serial.print("\n");
  
  for(i=0;i<s.length();i++){
    if(s[i] == ',')
      a = i;
  }
  
  if(s[0] == '-')
    in1= INPUT_1;         //Hacia atras
  else
    in1= INPUT_2;         //Hacia adelante
  
  if(s[a+1] == '-')
    in2= INPUT_3;         //Hacia atras
  else
    in2= INPUT_4;         //Hacia adelante
  
  Serial.print("Pin M1: ");Serial.print(in1);Serial.print("\n");
  Serial.print("Pin M2: ");Serial.print(in2);Serial.print("\n");

  r1 = "";
  for(i=0;i<a;i++){
    if(s[i] != '-'){
      r1 = r1 + s[i];
    }
  } 

  r2 = "";
  for(i=a+1;i<s.length();i++){
    if(s[i] != '-'){
      r2 = r2 + s[i];
    }
  }

  m1 = r1.toInt();
  m2 = r2.toInt();
  Serial.print("m1: ");Serial.print(m1);Serial.print("\n");
  Serial.print("m2: ");Serial.print(m2);Serial.print("\n");
  digitalWrite(in1,HIGH);
  digitalWrite(in2,HIGH);
  analogWrite(ENABLE_A,m1);
  analogWrite(ENABLE_B,m2);
  delay(250);
  digitalWrite(in1,LOW);
  digitalWrite(in2,LOW);
  analogWrite(ENABLE_A,0);
  analogWrite(ENABLE_B,0);
}

String readBT()
{
  char c;
  String aux = "";
  while(1){
  if(BTSerial.available())
  {
    c = BTSerial.read();
    if(c == 'f')
      break;
    aux = aux + c;   
  }}
  return aux;
}

char asciiToChar(char a)
{
  if ((a >= '0') && (a <= '9'))
    return a - '0';
  else
    return 0;
}
