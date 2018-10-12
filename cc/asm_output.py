import typing

#generic asm exception, probably from parsing
class AsmException(Exception):
  pass

#A class that describes a single assembly cmd, be it a comment, label, or cmd
class _AsmCmd:
  def __init__(self):
    #assembley representation - generated from other forms
    self.asm = ""
    #comment
    self.is_comment = False
    self.comment = ""
    #label
    self.is_label = False
    self.label = ""
    #marker - a numeric label
    self.is_marker = False
    self.marker = 0
    #cmd
    self.is_cmd = False
    self.cmd = ""
    #a label arg
    self.is_cmd_label = False
    self.arg_label = ""
    #a numeric arg
    self.is_cmd_val = False
    self.arg_val = 0
    #a numeric label - a marker
    self.is_cmd_marker = False
    self.arg_marker = 0

  @staticmethod
  def from_comment(comment: str) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_comment = True
    res.comment = comment
    return res

  @staticmethod
  def from_label(label: str) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_label = True
    res.label = label
    return res

  @staticmethod
  def from_marker(marker: int) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_marker = True
    res.marker = marker
    return res

  @staticmethod
  def from_cmd_label(cmd: str, arg: str) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_cmd = True
    res.cmd = cmd
    res.arg_label = arg
    res.is_cmd_label = True

    return res

  @staticmethod
  def from_cmd_val(cmd: str, arg: int) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_cmd = True
    res.cmd = cmd
    res.arg_val = arg
    res.is_cmd_val = True

    return res

  @staticmethod
  def from_cmd_marker(cmd: str, arg: int) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_cmd = True
    res.cmd = cmd
    res.arg_marker = arg
    res.is_cmd_marker = True

    return res

  @staticmethod
  def from_asm(asm: str) -> '_AsmCmd':
    #parse from raw asm
    #used for things like inline assembly in c programs, included .s files, etc

    #replace double spaces with tabs
    asm = asm.replace("  ", "\t").replace("\t ", "\t").replace(" \t", "\t").replace("\t\t", "\t")
    #trim end
    asm = asm.rstrip()
    #check if it is a comment
    if asm[0] == ';':
      #return comment, removing the leading tabs
      return _AsmCmd.from_comment(asm[1:].lstrip())
    #check if it is a cmd
    elif asm[0] == "\t":
      #replace just spaces with tabs - only do it here to save comments, etc
      asm = asm.replace(" ", "\t").replace("\t\t", "\t")
      #split asm
      split_asm = asm.split("\t")
      #check if it doesn't have an arg
      if len(split_asm) == 2:
        return _AsmCmd.from_cmd_label(split_asm[1], "")
      #cmd with arg
      if len(split_asm) == 3:
        #val arg
        if split_asm[2][0] == "#":
          return _AsmCmd.from_cmd_val(split_asm[1], int(split_asm[2][1:]))
        #marker arg
        elif split_asm[2][0] == "$":
          return _AsmCmd.from_cmd_marker(split_asm[1], int(split_asm[2][1:]))
        #label arg
        else:
          return _AsmCmd.from_cmd_label(split_asm[1], split_asm[2])
      raise AsmException("\nAsmException\nasm cmds need one command and at most one arg\nAt:\n" + asm)
    #or it is a label/marker
    else:
      #check if it is a marker
      is_marker = True if asm[0] == '$' else False
      #cut off trailing :
      if asm[-1] != ":":
        raise AsmException("\nAsmException\nLabels and markers must be followed by :\nAt:\n" + asm)
      asm = asm[:-1]
      if is_marker:
        return _AsmCmd.from_marker(int(asm[1:]))
      else:
        return _AsmCmd.from_label(asm)

  #generate the asm for a command, returning it
  def gen_asm(self) -> str:
    #comment line
    if self.is_comment:
      self.asm = ";\t" + self.comment + "\n"
    #label
    elif self.is_label:
      self.asm = self.label + ":\n"
    #marker
    elif self.is_marker:
      self.asm = "$" + str(self.marker) + ":\n"
    #asm command
    elif self.is_cmd:
      if self.is_cmd_label:
        self.asm = "\t" + self.cmd.ljust(4) + "\t" + self.arg_label + "\n"
      elif self.is_cmd_val:
        self.asm = "\t" + self.cmd.ljust(4) + "\t#" + str(self.arg_val) + "\n"
      elif self.is_cmd_marker:
        self.asm = "\t" + self.cmd.ljust(4) + "\t$" + str(self.arg_marker) + "\n"
    return self.asm


#A class to output assembly into, allowing for later optomization and passing to assembler
class AsmOutput:
  def __init__(self):
    #asm output
    self.lines = []

  #functions to add asm out
  def comment(self, comment: str) -> None:
    self.lines.append(_AsmCmd.from_comment(comment))

  def label(self, label: str) -> None:
    self.lines.append(_AsmCmd.from_label(label))

  def marker(self, marker: int) -> None:
    self.lines.append(_AsmCmd.from_marker(marker))

  def cmd(self, cmd: str) -> None:
    self.lines.append(_AsmCmd.from_cmd_label(cmd, ""))

  def cmd_val(self, cmd: str, val: int) -> None:
    self.lines.append(_AsmCmd.from_cmd_val(cmd, val))

  def cmd_label(self, cmd: str, label: str) -> None:
    self.lines.append(_AsmCmd.from_cmd_label(cmd, label))

  def cmd_marker(self, cmd: str, marker: int) -> None:
    self.lines.append(_AsmCmd.from_cmd_marker(cmd, marker))

  def asm(self, asm:str) -> None:
    self.lines.append(_AsmCmd.from_asm(asm))

  def print_asm(self) -> None:
    for l in self.lines:
      #ignore newlines for printing
      print(l.gen_asm()[:-1])

  #write asm to file
  def write_to_file(self, file) -> None:
    for l in self.lines:
      file.write(l)