#priv/python/test.py
import time
import sys
#import erlport modules and functions
from erlport.erlang import set_message_handler, cast
from erlport.erlterms import Atom

message_handler = None #reference to the elixir process to send result to

def cast_message(pid, message):
    cast(pid, message)

def register_handler(pid):
    #save message handler pid
    global message_handler
    message_handler = pid

def handle_message(count):
    try:
        print "Received message from Elixir"
        print count
        result = long_counter(count)
        if message_handler:
           #build a tuple to atom {:python, result}
           cast_message(message_handler, (Atom('python'), result))
    except Exception, e:
      # you can send error to elixir process here too
      # print e
      pass
def long_counter(count=100):
    #simluate a time consuming python function
    i = 0
    data = []
    while i < count:
        time.sleep(1) #sleep for 1 sec
        data.append(i+1)
        i = i + 1
    return data

set_message_handler(handle_message) #set handle_message to receive all messages sent to this python instance