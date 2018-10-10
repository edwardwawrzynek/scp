import typing

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
    #cmd
    self.is_cmd = False
    self.cmd = ""
    self.arg_label = ""
    self.arg_val = 0
    #if the arg is a number or label (False = label, True in num)
    self.is_val_arg = False

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
  def from_cmd_label(cmd: str, arg: str) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_cmd = True
    res.cmd = cmd
    res.arg_label = arg
    res.is_val_arg = False
    return res

  @staticmethod
  def from_cmd_val(cmd: str, arg: int) -> '_AsmCmd':
    res = _AsmCmd()
    res.is_cmd = True
    res.cmd = cmd
    res.arg_val = arg
    res.is_val_arg = True
    return res

  #generate the asm for a command, returning it
  def gen_asm(self) -> str:
    #comment line
    if self.is_comment:
      self.asm = ";\t" + self.comment + "\n"
    #label
    elif self.is_label:
      self.asm = self.label + ":\n"
    #asm command
    elif self.is_cmd:
      if self.is_val_arg:
        self.asm = "\t" + self.cmd + "\t#" + str(self.arg_val) + "\n"
      else:
        self.asm = "\t" + self.cmd + "\t" + self.arg_label + "\n"
    return self.asm


#A class to output assembly into, allowing for later optomization and passing to assembler
class AsmOutput:
  def __init__(self):
    #asm output
    self.lines = []

  #functions to add asm out
  def comment(self, comment: str) -> None:
    self.lines.append(_AsmCmd.from_comment(comment))

  def label(self, label: str, is_mod: bool = False) -> None:
    if is_mod:
      self.lines.append(_AsmCmd.from_label("$" + label))
    else:
      self.lines.append(_AsmCmd.from_label(label))

  def cmd(self, cmd: str, arg: typing.Union[str, int] = "", is_mod: bool = False) -> None:
    if type(arg) == int:
      self.lines.append(_AsmCmd.from_cmd_val(cmd, int(arg)))
    else:
      if is_mod:
        self.lines.append(_AsmCmd.from_cmd_label(cmd, "$"+str(arg)))
      else:
        self.lines.append(_AsmCmd.from_cmd_label(cmd, str(arg)))

  def print_labels(self) -> None:
    for l in self.lines:
      #ignore newlines for printing
      print(l.gen_asm()[:-1])

  #write asm to file
  def write_to_file(self, file) -> None:
    for l in self.lines:
      file.write(l)