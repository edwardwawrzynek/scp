#!/usr/bin/python

import serial, sys, time
import serial.tools.list_ports

if len(sys.argv) >= 3:
    ser = serial.Serial(sys.argv[2])
else:
    ser = serial.Serial()
    ser.port = "FALSE"

ser.baudrate = 115200

def print_usage():
    print "\n--------------------\n- SCP Prgm Send -\nUsage:\nscpsnd <bin file> <serial port (optional)>\n--------------------"
    exit()

if ser.port == "FALSE":
    for p in serial.tools.list_ports.comports():
        if "uart" in p[1].lower() and ser.port == "FALSE":
            ser.port = p[0]

if ser.port == "FALSE":
    print "No Port Specified, and no UART Port Found. Terminating"
    exit()

if not ser.isOpen():
    ser.open()

if ser.isOpen():
    ser.read(ser.inWaiting())
else:
    print "Port Failed to open"
    exit()

if len(sys.argv) < 2:
    print_usage()

path = sys.argv[1]
print "Transmiting " + path + " to " + ser.port

sys.stdout.write("|")
for i in range(78):
    sys.stdout.write("-")
sys.stdout.write("|\n")
sys.stdout.flush()

f = open(path, 'r')
data = f.read()
f.close()
def sendChunk(index, length):
    if len(data) < index+length:
        length = len(data)-index
    for i in range(index, index+length):
        ser.write(data[i])
        time.sleep(0.0002)
    while ser.inWaiting() < length:
        pass
    ser.read(ser.inWaiting())

cur = 0
chunk_len = 128
for i in range(len(data)):
    if i % chunk_len == 0:
        sendChunk(i, chunk_len)
    while int((float(i)/float(len(data)))*80.0) >= cur:
        cur += 1
        sys.stdout.write("#")
        sys.stdout.flush()

ser.write(chr(0xf0));
ser.write(chr(0x0f));
ser.write(chr(0xff));
ser.write(chr(0x00));
sys.stdout.write("\n")
sys.stdout.flush()
print "Sent"
