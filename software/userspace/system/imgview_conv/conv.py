#! /bin/env python3 

import sys
import numpy
import cv2

def preview_color(color):
  return [(color[0] >> 6) << 6, (color[1] >> 5) << 5, (color[2] >> 5) << 5]

def conv_color(color):
  r = color[2]
  g = color[1]
  b = color[0]
  return ((b>>6) + ((g>>5)<<2) + ((r>>5)<<5))

def main(inpath, outpath):
  img = cv2.imread(inpath)
  img = cv2.resize(img, (320, 200))

  out = open(outpath, "wb")

  
  for y in range(200):
    for x in range(320):
      img[y][x] = preview_color(img[y][x])
      out.write(bytes([conv_color(img[y][x])]))
  
  out.close()
  cv2.imshow("image", img)
  cv2.waitKey(0)

if len(sys.argv) != 3:
  print("usage: conv.py in_image out_image")
  exit(1)

main(sys.argv[1], sys.argv[2])