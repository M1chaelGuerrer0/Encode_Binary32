# FILE: encode_binary32.j
# Description:
#   This file provides the code to convert a binary number presented in 
#   Scientific Notation into binary32 format.  The binary32 format is as follows:
#
#     binary_32:   |  s  | eeee eeee | mmm mmmm mmmm mmmm mmmm mmmm |
#                  | <1> | <-  8  -> | <-          23            -> |
#
#     the sign bit is placed into position 32
#     the biassed exponent (8 bits) is placed into positions: 31 .. 24
#     the mantissa is left-justified (within it's 23-bit field),
#       and is placed in positions: 23 .. 1          
#
#  Given a the following binary number (as an example):
#      2# + 1.1 0100 1110 0001 x 2^ - 101
#
#  The input for the to sub routine is as follows:
#
#     sign    coefficient       expon_sign   exponent
#      '+'    2#11010011100001  '-'          2#101
#
#  Note: the coefficient is represented in fix-point notation in which the radix
#        point is always located immediately to the right of the msb.

                .text
                .globl encode_binary32
                .include "macros/syscalls.s"
                .include "macros/subroutine.s"
                .include "macros/stack.s"


                # The following is test input to help you in your initial debugging
                # When running this file via MARS.

                li $a0, '+'    # 0x2b (43)
                li $a1, 0x34E1 # (0011 0100 1110 0001) 
                li $a2, '-'    # 0x2d   (45)
                li $a3, 0x29   # (41)
                jal encode_binary32
                exit()

                # Use mips_subroutine to perform additional testing


                .macro call( %sub, %arg)
                  save_state()
                  push($a0)
                  move $a0, %arg
                  jal %sub
                  pop($a0)
                  restore_state()
                .end_macro

encode_binary32: nop
                # Prototype:  encode_binary32( sign, coefficient, expon_sign, expon )
                # Formal Parameters:
                # a0: sign -- an ASCII character
                # a1: coefficient (representing, in total,:  1.\<mantissa\>) 
                # a2: expon_sign -- an ASCII character
                # a3: exponent (unbiased)
                # v0: encoding -- the encoded binary32 value
        
                # Initial Register Allocation
                # t0: sign
                # t1: coefficient
                # t2: expon_sign
                # t3: exponent

                # Additional Register Allocation
                # t4: encoded_sign
                # t5: encoded_mantissa
                # t6: encoded_exponent;
                # t7: position -- the location of the msb of the coefficient
                # t8: coeeficient_shift
                # t9: negative_sign

                # The following do not get registers since they are all immediates
                #    used with the shift operations.  They are provide here for 
                #    as assemble literals:

                .eqv bias 127                   #  final int bias           = 127;  // As defined by the spec
                .eqv sign_shift 31              #  final int sign_shift     =  31;  //   << (8 + 23 )
                .eqv expon_shift 23             #  final int expon_shift    =  23;  //   << (23)
                .eqv mantissa_shift  9          #  final int mantissa_shift =   9;  //  >>> (8+1)  // the mantissa is left-justified
                                                #  final int $zero          =   0;  


                # Demarshal your input arguments
                move $t0, $a0
                move $t1, $a1
                move $t2, $a2
                move $t3, $a3

                #/////////////////////////////////////////////////////////
                #// BEGIN CODE of INTEREST
                #/////////////////////////////////////////////////////////
                 
                li $t9, '-'                                # $t5 = '-';     // Define the value  
sign:           nop
                bne $t0, $t9, alt               # if ($a0 == $t5) {
con:            nop                             # ;
                li $t4, 1                       # $t0 = 1;
                b complete                          # // goto done;
alt:            nop                             # } else{  ;
                move $t4, $zero                 #   $t0 = $zero;
                b complete                          # // goto done;
complete:       nop                             # } ;
exponet:        nop                             # ;
                bne $t9, $t2, no                # if ($a2 == $t5) {
yes:            nop                             # ;
                sub $t3, $zero, $t3             # $t2= -($a3);
                addi $t6, $t3, bias              # $t2 += $t6;
                b finish                        # // goto finish;
no:             nop                             # } else{ ;
                                                # $t2 = $a3;
                addi $t6, $t3, bias              # $t2 += $t6;
                b finish                        # // goto finish;
finish:         nop                             # } ;
                
                call pos_msb $t1                # $t3 = pos_msb($a1);
                move $t7, $v0
                sub  $t7, $zero, $t7              # $t3 = $t7 - $t3;
                addi $t8, $t7, 33
                sllv $t8, $t1, $t8               # $t4 = $a1 << $t3; 
                move $t5, $t8                       # $t1 = $t4;
            
                sll $t4, $t4, sign_shift        # $t0 = $t0 << $t7;
                sll $t6, $t6, expon_shift       # $t2 = $t2 << $t8;
                srl $t5, $t5, mantissa_shift    # $t1 = $t1 >>> $t9;
                                                       # $t1 = $t1 & 0x7FFFFF;         
            
                or $v0, $t4, $t6
                or $v0, $v0, $t5                # $v0 = $t0 | $t2 | $t1;
                move $v0, $v0                  
                jr $ra                          # return $v0;
  

                #/////////////////////////////////////////////////////////
                #// END CODE of INTEREST
                #/////////////////////////////////////////////////////////



pos_msb:  nop                           # int pos_msb(int number)
        # a0:  number
        # v0:  counter -- return value
        # t0:  number

        # Demarshal your input arguments
        move $t0, $a0                   

        li $v0, 0                       # counter = 0;
init:   nop                             # init:  ;
loop:   beq $t0, $zero, done            # loop:  for(; number != zero ;) {
body:     nop                           # body:     ;
          addi $v0, $v0, 1              #           counter ++;
          srl $t0, $t0, 1               #           number = number >> 1;
        b loop                          #           contine loop;
                                        #        }
done:   nop                             # done:  nop
        move $v0, $v0                   #        return counter;
        jr $ra







# Task 3 complete: Tue Oct 24 21:52:02 PDT 2023
