import sys
import os
import io
import math
import logging
from antlr4 import *
from MAPINFOLexer import MAPINFOLexer
from MAPINFOParser import MAPINFOParser
from MAPINFOVisitor import MAPINFOVisitor
from MAPINFOListener import MAPINFOListener
from collections import namedtuple
from dotdict import dotdict

class MAPINFO(MAPINFOListener):
  def __init__(self):
    self.maps = {}
    self.gameinfo = dotdict({
      "credits":"gAME eNGINE:,@fsouchu"
    })

  def exitMapblock(self, ctx):  
    lump = ctx.maplump().getText()
    label = ctx.label().getText().strip('"')
    logging.info("Found map entry: {} label: {}".format(lump, label))
    properties = {}
    for pair in ctx.pair():
      attribute = pair.keyword().getText().lower()
      value = pair.value().getText().strip('"')
      if attribute in ['levelnum','music']:
        value = int(value)
      
      # else string
      properties[attribute] = value
                
    self.maps[lump] = dotdict({
      'name': lump,
      'group': lump[:2].lower(),
      'label': label,
      # background sky (optional)
      'sky': properties.get('sky1',None),
      # need first entry only
      'num': properties.get('levelnum',-1),
      # music (or none)
      'music': properties.get('music',-1),
      'next': properties.get('next','endgame')
    })
  
  def exitInfoblock(self, ctx):
    for pair in ctx.pair():
      attribute = pair.keyword().getText().lower()
      value = pair.value().getText().strip('"')
      self.gameinfo[attribute] = value

  
# Converts a TEXTURE file definition into a set of unique tiles + map index
class MapinfoReader(MAPINFOListener):
  def __init__(self, stream):
    self.stream = stream
  
  def read(self):    
    # get data
    data = self.stream.read("ZMAPINFO").decode('ascii')

    lexer = MAPINFOLexer(InputStream(data))
    stream = CommonTokenStream(lexer)
    parser = MAPINFOParser(stream)
    tree = parser.maps()
    walker = ParseTreeWalker()

    listener = MAPINFO()
    walker.walk(listener, tree)
    
    # find first level
    curmap = next((m for n,m in listener.maps.items() if m.num==1), None)
    if curmap is None:
      raise Exception("ZMAPINFO: Missing starting map (levelnum=1)")
    allmaps = [curmap]
    while curmap is not None:
      if curmap.next == 'endgame':
        break
      if curmap.next not in listener.maps:
        raise Exception("ZMAPINFO: Map {} references unknown next map: {}".format(curmap.name, curmap.next))
      curmap = listener.maps[curmap.next]
      allmaps.append(curmap)

    return allmaps,listener.gameinfo

