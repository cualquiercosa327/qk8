import sys
import copy
from antlr4 import *
from DECORATELexer import DECORATELexer
from DECORATEParser import DECORATEParser
from DECORATEVisitor import DECORATEVisitor
from DECORATEListener import DECORATEListener
from collections import namedtuple
from dotdict import dotdict
from enum import IntFlag

class ACTOR_KIND(IntFlag):
  # inventory items
  KEY = 0
  AMMO = 1
  WEAPON = 2
  HEALTH = 3
  ARMOR = 4
  # generic class
  DEFAULT = 5
  MONSTER = 6
  PROJECTILE = 7
  PLAYER = 8

builtin_actors = {
  'key':{
    'kind': ACTOR_KIND.KEY,
    'amount': 1,
    'maxamount':1,
    'radius': 20,
    'icon': 10
  },
  'ammo':{
    'kind': ACTOR_KIND.AMMO,
    'radius': 20
  },
  'weapon':{
    'kind': ACTOR_KIND.WEAPON,
    'radius': 20,
    'amount': 0,
    'maxamount': 1
  },
  'health':{
    'kind': ACTOR_KIND.HEALTH,
    'radius': 20,
    'maxamount': 200
  },
  'armor':{
    'kind': ACTOR_KIND.ARMOR,
    'radius': 20,
    'maxamount': 200
  },
  'player':{
    'kind': ACTOR_KIND.PLAYER,
    'radius': 32,
    'armor': 100,
    'health': 100,
    'speed': 3,
    'shootable': True,
    'solid': True
  },
  'monster':{
    'kind': ACTOR_KIND.MONSTER,
    'radius': 32,
    'armor': 0,
    'health': 50,
    'shootable': True,
    'solid': True
  },
  'projectile':{
    'kind': ACTOR_KIND.PROJECTILE,
    'damage': 1,
    'speed': 5
  }
}

class DecorateWalker(DECORATEListener):     
    def __init__(self):
      self.result = {}
      self.labels = {}
      self.last_label = None
      self.states = []

    def enterBlock(self, ctx):
      # clear states
      self.labels = {}
      self.last_label = None
      self.states = []

    def exitBlock(self, ctx):  
      name = ctx.name().KEYWORD().getText().lower()

      if name in builtin_actors:
        raise Exception("Cannot redefine base actor: {}".format(name))
      # -1 = not exported
      id = -1
      if ctx.uid():
        id = int(ctx.uid().getText())
      properties = dotdict({
        # debug/error mgt purpose only
        'name': name,
        'id': id,
        'kind': ACTOR_KIND.DEFAULT,
        'radius': 20,
        'height': 16
      })
      if ctx.parent():
        parent = ctx.parent().KEYWORD().getText().lower()
        if parent not in self.result and parent not in builtin_actors:
          raise Exception("Actor {} references unknown parent: {}".format(name, parent))
        # built-in parent or user defined?
        if parent in builtin_actors:
          parent = builtin_actors[parent]
        else:
          parent = self.result[parent]
        # copy parent properties in self
        for k,v in parent.items():
          if k=='id':
            properties['parent']=id 
          else:
            properties[k]=v

      for pair in ctx.pair():
        attribute = pair.keyword().getText().lower()
        value = pair.value().getText().lower().strip('"')
        if attribute in []:
          value = value=='true'
        elif attribute in ['health','armor','height','radius','slotnumber','amount','maxamount','damage','speed','ammogive','ammouse','icon']:
          value = int(value)
        elif attribute in ['ammotype','projectile']:
          if value not in self.result:
            raise Exception("Actor: {} references unknown: {}".format(name, value))
          otheractor = self.result[value]
          value = otheractor.id
        elif attribute in ['startitem']:
          if value not in self.result:
            raise Exception("Actor: {} references unknown start item: {}".format(name, value))
          otheractor = self.result[value]
          startitems = properties.get('startitems',[])
          # default amount
          amount = 1
          # so far, only ammo can have startitem params
          values = pair.args().value
          if otheractor.kind == ACTOR_KIND.AMMO and len(values())>0:
            amount = int(values(0).getText())
          startitems.append((otheractor.id, amount))
          value = startitems
          attribute = 'startitems'
        
        # else string
        properties[attribute] = value
      
      # flags
      for flag in ctx.flags():
        activated = flag.ENABLED().getText()
        attribute = flag.keyword().getText().lower()
        properties[attribute] = activated=='+'
      
      # loop/goto index is encoded in a byte
      if len(self.states)>255:
        raise Exception("Exceeded max. number of states: {}/255".format(len(self.state)))

      # states
      states = []
      for i,state in enumerate(self.states):
        if 'goto' in state:
          label = state.goto
          if label not in self.labels:
            raise Exception("Unknown goto label: {} in {}".format(label,list(self.labels.keys())))
        states.append(state)
        # print("{}: {}".format(i,state))

      properties['_states'] = states
      properties['_labels'] = copy.deepcopy(self.labels)

      self.result[name] = properties

    def exitState_block(self, ctx):
      if ctx.label():
        label = ctx.label().KEYWORD().getText()
        self.labels[label] = len(self.states)
        self.last_label = label 
      elif ctx.state_command():
        state = ctx.state_command()
        self.states.append(dotdict({
          'image': state.image().getText(),
          'variant': state.variant().getText(),
          'bright': state.image_modifier() is not None,
          'ticks': int(state.ticks().getText())
        }))
      elif ctx.state_stop():
        self.states.append(dotdict({
          'stop': True
        }))
      elif ctx.state_loop():
        if self.last_label is None:
          raise Exception("No state label to loop to.")
        self.states.append(dotdict({
          'goto': self.last_label
        }))
      elif ctx.state_goto():
        label = ctx.state_goto().KEYWORD().getText()
        # go to yet undeclared label is possible !!
        # to be resolved later on
        self.states.append(dotdict({
          'goto': label
        }))

class ACTORS():
  def __init__(self, data):
    lexer = DECORATELexer(InputStream(data))
    stream = CommonTokenStream(lexer)
    parser = DECORATEParser(stream)
    tree = parser.actors()
    walker = ParseTreeWalker()

    decorate_walker = DecorateWalker()
    walker.walk(decorate_walker, tree)
    self.actors = decorate_walker.result
