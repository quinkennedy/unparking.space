#!/usr/bin/env python

import opc, time, math

# initialize pixels array
pixels = [(0,0,0) for i in range(512)]
# channel 1 is dicey, so we'll skip it
LED_OFFSET = 64

class Hand:
  NUM_LEDS = 6
  COLOR = (255, 0, 255)
  PERIOD_MIN = 3
  PERIOD_MAX = 5
  BRIGHT_MIN = .4
  BRIGHT_MAX = .7
  time_offset = 0
  period = PERIOD_MIN
  index = 0
  client = None

  def __init__(self, index, client):
    self.index = index
    self.client = client
    self.setColor(self.COLOR)

  def setColor(self, color):
    startI = self.index * self.NUM_LEDS + LED_OFFSET
    for i in range(startI, startI + self.NUM_LEDS):
      pixels[i] = color
    self.client.put_pixels(pixels)

  def update(self):
    brightness = math.sin(time.time() * math.pi / self.period) # [-1, 1]
    brightness = brightness + 1 / 2 # [0, 1]
    brightness = brightness * (self.BRIGHT_MAX - self.BRIGHT_MIN) + self.BRIGHT_MIN # [min, max]
    currColor = [i*brightness for i in self.COLOR]
    self.setColor(currColor)

client = opc.Client('localhost:7890')
hands = [Hand(0, client)]

while True:
  for hand in hands:
    hand.update()
  time.sleep(1/60)
