p#Hola
import Adafruit_BBIO.PWM as PWM
#import asyncio
import Adafruit_BBIO.UART as UART
import serial 
#PWM:
import time
import json
UART.setup("UART1") #BT en el UART1: RX:P9_26; TX:P9_24; CTS:P9_20; RTS:P9_19; Device:/dev/ttyO1
ser = serial.Serial(port = "/dev/ttyO1", baudrate=9600)
ser.close()

PWM.start("P9_14", 0) #Derecha, 0
PWM.start("P9_16", 0) #70
PWM.start("P8_13", 0) #Izquierda, 80
PWM.start("P8_19", 0)  #0
#@asyncio.coroutine
def main():
    
	ser.close()
	ser.open()
	while ser.isOpen():
		
		x = ser.read(84)   # read a '\n' terminated line
		print(x)
		d = json.loads(x)
		print(d)
		#print(d["Motor1.1"])
		
		#x='{"Motor1.1":0, "Motor1.2":100, "Motor2.1":100,"Motor2.2":0}'
		#d={"Motor1.1":"100", "Motor1.2":"100", "Motor2.1":"100","Motor2.2":"100","tiempo":"1"}
		Motores(d["Motor1.1"],d["Motor1.2"],d["Motor2.1"],d["Motor2.2"],d["tiempo"])
		
	ser.close()


	
def Motores(duty1,duty2,duty3,duty4,tiempo):
	print("va a adelante")
	PWM.set_duty_cycle("P9_14", float(duty1)) #Derecha, 0
	PWM.set_duty_cycle("P9_16", float(duty2))#70
	PWM.set_duty_cycle("P8_13", float(duty3)) #Izquierda, 80
	PWM.set_duty_cycle("P8_19", float(duty4))  #0
	time.sleep(tiempo)
	PWM.set_duty_cycle("P9_14", 0) #Derecha, 0
	PWM.set_duty_cycle("P9_16", 0) #70
	PWM.set_duty_cycle("P8_13", 0) #Izquierda, 80
	PWM.set_duty_cycle("P8_19", 0)  #0


main()	