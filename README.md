# Binary32: The Encoding of the Java float type

## Overview:

In this assignment, I develop three versions of a method/subroutine that encodes a real binary number into binary32 format.  This real number can be represented in scientific notation.  

My method/subroutine has four arguments that correspond to the four fields in the number's scientific notation representation.  These four fields are:
   1. the sign of the real number: '+'
   1. the coefficient: "2#1 1 0100 1110 0001"
      - the coefficient represents both the whole number and the mantissa.
      - the coefficient is an integer value provided in fix point.
      - the radix point is set after the first digit from the left. 
   1. the sign of the exponent: '-'
   1. the exponent: 41


## Testing for the command line:
Example:
```bash
     java_subroutine encode_binary32  '+' 0x34E1 '-' 0x29
     #########################################
     # Above is the output from your program
     #########################################
                  |
     v0: 726893568; 0x2B 53 84 00; 0b0010 1011 0101 0011 1000 0100 0000 0000;
     
```

  * You may use the `make` file to automate the testing of your program.

     * `make test_java_code`: tests your Java code
     * `make test_mips_code`: tests your MIPS code
    