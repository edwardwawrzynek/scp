class Defs:
  #base reg size
  REG_SIZE = 2
  #sizes of each basic variable type
  CHAR_SIZE = 1
  SHORT_SIZE = 2
  INT_SIZE = 2
  LONG_SIZE = 4

  POINTER_SIZE = 2

  #output an error
  #TODO: move this from the Defs class to something more appropriate
  @staticmethod
  def error(msg: str):
    print("Error\n" + msg)
    exit(1)