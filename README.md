# x86-16-disassembler
Partial 16-bit disassembler written in 16-bit assembly, modeled for intel 8086 architecture

This was an optional task for extra credit in my Computer Architecture course.
The disassembler itself is a majorly simplified version as writing a proper disassembler in a couple months for an Undergraduate student would be rather ludicrous and for the goal of this task, which is to understand the inner workings of code, this is sufficient.

The disassembler will only work on the .COM format, which is essentially a simplified variant of .EXE.
Partial means it doesn't understand all of the commands, just the most common ones.

HOW TO USE THIS:
You will need a 16 bit coprocessor emulator, I used TASM.

Running this on TASM:
1. Mount a directory and go to it. E. g. 
    >mount g C:\Users\Desktop\Somewhere\Here
    
    >g:
2. Assemble the disassembler :) and link it
    >tasm disassembler.asm
    
    >tlink disassembler.obj
    
    This creates an .exe of the disassembler.
3. Assemble the code to disassemble and link it
    >tasm example-code.asm
    
    >tlink /t example-code.obj
    
    notice the /t as we're making this a .com not an .exe
4. Run it
    >disassembler example-code.com RESULT-FILE-NAME.txt
    
    NOTE: the file names should be 5 characters or less, due to certain restraints in the architecture
    
There is a result.txt file to showcase what you should get while disassembling the example-code file
