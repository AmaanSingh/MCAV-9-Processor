"""
usage: python assembler.py [assembly file] [machine code file]

requires python 3.x
"""

import sys

# map registers to binary
registers_two_bit = {
    "r0": "00",
    "r1": "01",
    "r2": "10",
    "r3": "11",
}

registers_three_bit = {
    "r0": "000",
    "r1": "001",
    "r2": "010",
    "r3": "011",
    "r4": "100",
    "r5": "101",
    "r6": "110",
    "r7": "111",
}

# classify instructions into different types
# NOTE: THIS WILL BE DIFFERENT FOR YOU!
math = {
    'add':'000', 
    'sub': '001',
    'and': '010',
    'or': '011',
    'xor': '100',
    'ls': '101',
    'rs': '110',
    'not': '111',
}
conditions = {
    'bl': '00',
    'bg': '01',
    'bne': '10',
    'beq': '11',
}
assignments_inter = {
    'li': '000',
}
assignments_nop = {
    'nop': '101',
}
assignments = {
    'cntr': '001',
    'load': '010',
    'store': '011',
    'cmp': '100',
    'cntr': '001',
}
values = {
    'mov': '0',
}
values_inter = {
    'jmp': '1',
}

# NOTE: THIS WILL BE DIFFERENT FOR YOU!
comment_char = '#'

with (
    open(sys.argv[1], "r") as read,
    open(sys.argv[2], "w") as write
):
# with automatically handles file (no need for open and close)
    line = read.readline() # read a line

    # for every line
    while(line):
        # strip takes away whitespace from left and right
        line = line.strip()

        # split your comments out
        line = line.split(comment_char, 1)

        # store instruction and comment
        inst = line[0].strip()
        comment = line[1].strip() if len(line) > 1 else ""
        #comment = line[1].strip()

        # split instruction into arguments
        inst = inst.split()
        print(inst)

        # initialize the string that contains the machine code binary
        writeline = ''

        if inst[0] in math:
            writeline += "00"
            writeline +=math[inst[0]]
        elif inst[0] in conditions:
            writeline += "01"
            writeline += conditions[inst[0]]
        elif inst[0] in assignments_inter:
            writeline += "10"
            writeline += assignments_inter[inst[0]]
        elif inst[0] in assignments_nop:
            writeline += "10"
            writeline += assignments_nop[inst[0]]
        elif inst[0] in assignments:
            writeline += "10"
            writeline += assignments[inst[0]]
        elif inst[0] in values:
            writeline += "11"
            writeline += values[inst[0]]
        elif inst[0] in values_inter:
            writeline += "11"
            writeline += values_inter[inst[0]]
        else:
            sys.exit()

        # write the first register to binary (maybe you need checking on this)
        #writeline += registers_two_bit[inst[1]]

        # if it's r-type or b-type, then you know you have 2 args after (this might be different for you)
        if inst[0] in math or inst[0] in assignments:
            writeline += registers_two_bit[inst[1]]
            writeline += registers_two_bit[inst[2]]
        elif inst[0] in conditions:
            if inst[1].startswith('$'):
                writeline += format(int(inst[1][1:]), '05b')
        elif inst[0] in assignments_inter:
            if inst[1].startswith('$'):
                writeline += format(int(inst[1][1:]), '04b')
        elif inst[0] in assignments_nop:
                writeline += '0000'
        elif inst[0] in values:
            writeline += registers_three_bit[inst[1]]
            writeline += registers_three_bit[inst[2]]
        elif inst[0] in values_inter:
            if inst[1].startswith('$'):
                writeline += format(int(inst[1][1:]), '06b')

        # SystemVerilog ignores comments prepended with // with readmemb or readmemh
        if comment:
            writeline += ' //' + comment
        writeline += '\n'

        # write the line into the desired file
        write.write(writeline)

        # read the next line
        line = read.readline()
