#for the 3d sensor OMD-30-SE-100N
#f.olofsson 2017
#https://www.fredrikolofsson.com/f0blog/?q=node/649

#first argument is serial port, second ip and third port.  e.g.
#python optoforceOsc.py '/dev/tty.usbmodem1451' '127.0.0.1' 9999

import sys
from struct import *
from threading import Thread
import serial
from OSC import OSCServer, OSCClient, OSCMessage, OSCClientError

osc= OSCClient()
if len(sys.argv)>3:
  osc.connect((sys.argv[2], int(sys.argv[3])))  #send to address and port
else:
        osc.connect(('127.0.0.1', 57120))  #default send to sc on same computer

serport= '/dev/cu.usbmodem1411'
if len(sys.argv)>1:
  serport= sys.argv[1]

ser= serial.Serial(
  port= serport,
  baudrate= 1000000,
  parity= serial.PARITY_NONE,
  stopbits= serial.STOPBITS_ONE,
  bytesize= serial.EIGHTBITS,
  timeout= 1
)
print('connected to serial port: '+ser.portstr)

def oscInput(addr, tags, stuff, source):
  print stuff  #for now do nothing

server= OSCServer(('0.0.0.0', 9998))  #receive from everywhere
server.addDefaultHandlers()
server.addMsgHandler('/optoforceConfig', oscInput)
server_thread= Thread(target= server.serve_forever)
server_thread.start()

print('sending osc to: '+str(osc.address()))
print('listening for osc on port: '+str(server.address()[1]))

###configure sensor (optional)
conf= bytearray(9)
speed= 10  #0, 1, 3, 10, 33, 100 (default 10)
filter= 3   #0 - 6 (default 4)
zero= 255   #0, 255
checksum= 170+0+50+3+speed+filter+zero
conf[0]= 170
conf[1]= 0
conf[2]= 50
conf[3]= 3
conf[4]= speed
conf[5]= filter
conf[6]= zero
conf[7]= checksum>>8
conf[8]= checksum&255
ser.write(conf)

def main():
  while True:
    b= ser.read(4)
    header= unpack('BBBB', b)
    if header==(170, 7, 8, 10): #data
      b= ser.read(12)
      counter= unpack('>H', b[0:2])[0]
      status= unpack('>H', b[2:4])[0]
      xyz= unpack('>hhh', b[4:10])
      checksum= unpack('>H', b[10:12])[0]
      sum= (170+7+8+10)
      for i in range(10):
        sum= sum+ord(b[i])
      if checksum==sum:
        #print(counter, status, xyz)
        msg= OSCMessage()
        msg.setAddress('/optoforce')
        msg.append(xyz)
        try:
          osc.send(msg)
        except OSCClientError:
          print 'osc: could not send to address'
      else:
        print 'data: checksum error'
        print checksum
    else:
      if header==(170, 0, 80, 1): #status
        b= ser.read(3)
        status= unpack('B', b[0])[0]
        checksum= unpack('>H', b[1:3])[0]
        if checksum!=(170+0+80+1+status):
          print 'status: checksum error'
          print checksum
      else:
        print 'header: serial read error'
        print header

if __name__ == '__main__':
  try:
    main()
  except KeyboardInterrupt:
    server.close()
    server_thread.join()
    ser.close()
