// FILE: encode_binary32.j
// Description:
//   This file provides the code to convert a binary number presented in 
//   Scientific Notation into binary32 format.  The binary32 format is as follows:
//
//     binary_32:   |  s  | eeee eeee | mmm mmmm mmmm mmmm mmmm mmmm |
//                  | <1> | <-  8  -> | <-          23            -> |
//
//     the sign bit is placed into position 32
//     the biassed exponent (8 bits) is placed into positions: 31 .. 24
//     the mantissa is left-justified (within it's 23-bit field),
//       and is placed in positions: 23 .. 1          
//
//  Given a the following binary number (as an example):
//      2# + 1.1 0100 1110 0001 x 2^ - 101
//
//  The input for the to sub routine is as follows:
//
//     sign    coefficient       expon_sign   exponent
//      '+'    2#11010011100001  '-'          2#101
//
//  Note: the coefficient is represented in fix-point notation in which the radix
//        point is always located immediately to the right of the msb.


  public static int encode_binary32(int $a0, int $a1, int $a2, int $a3){
            // $a0 : sign
            // $a1 : coefficient
            // $a2 : expon_sign
            // $a3 : exponent
            // $v0 : encoding
            // $t0 : encoded_sign
            // $t1 : encoded_mantissa
            // $t2 : encoded_exponent
            // $t3 : position          
            // $t4 : coefficient_shift
            // $t5 : negative_sign
            // $t6 : bias
            // $t7 : sign_shift
            // $t8 : expon_shift
            // $t9 : mantissa_shift
            // $zero : 0

            int $v0; // : return value

            int $t0; 
            int $t1; 
            int $t2; 
            int $t3; // the location of the msb of the coefficient
            int $t4; 
            int $t5; 

            final int $t6 = 127;  // bias: As defined by the spec
            final int $t7 =  31;  // sign_shift:  << (8 + 23 )
            final int $t8 =  23;  // expon_shift:  << (23)
            final int $t9 =   7;  // mantissa_shift: >>> (8 - 1)  // the mantissa is left-justified
            final int $zero  = 0;  

            /////////////////////////////////////////////////////////
            // BEGIN CODE of INTEREST
            /////////////////////////////////////////////////////////

            $t5 = '-';     // Define the value

            /////////////////////////////////////////////////////////
            // 1. Encode each of the three fields of the floating point format:
            // 1.1 Sign Encoding (encoded_sign = )
            //     - Based upon the sign, encode the sign as a binary value
ifelse:       ;
            if ($a0 == $t5) {
con:          ;      
              $t0 = 1;
            // goto done;
            }
            else {
alt:          ;              
              $t0 = $zero;
            // goto done;
            }
done:       ;
            // 1.2 Exponent Encoding: (encoded_expon = )
            //     - Make the exponent a signed quantity
            //     - Add the bias
start:     ;
            if ($a2 == $t5) {
yes:          ;              
              $t2= -($a3);
              $t2 += $t6;
            // goto finish;
            }
            else{
no:           ;             
              $t2 = $a3;
              $t2 += $t6;
            // goto finish;
            }
finish:     ;            
            // 1.3  Mantissa Encoding (encoded_mantissa = )
            //      - Determine the number of bits in the coefficient
            //        - that is to say, find the position of the most-significant bit
            //      - Shift the coefficient to the left to obtain the mantissa
            //        - the whole number is now removed, and
            //        - the mantissa (which is a fractional value) is left-justified
            $t3 = pos_msb($a1);
            $t3 = $t7 - $t3;
            $t4 = $a1 << $t3; //using sign shift because it is 32 bits
            $t1 = $t4;
            /////////////////////////////////////////////////////////
            // 2. Shift the pieces into place: sign, exponent, mantissa
            $t0 = $t0 << $t7;
            $t2 = $t2 << $t8;
            $t1 = $t1 >>> $t9;
            $t1 = $t1 & 0x7FFFFF;    // 0x7FFFFF is 23, the size of the mantissa          
            /////////////////////////////////////////////////////////
            // 3. Merge the pieces together
            $v0 = $t0 | $t2 | $t1;
            return $v0;
  }

/////////////////////////////////////////////////////////
// END CODE of INTEREST
/////////////////////////////////////////////////////////

static int pos_msb(int number){
          // $a0 : number
          int counter;      // : counter: the return value

          counter = 0;
  init:   ;
  loop:   for(; number != 0 ;) {
  body:     ;
            counter ++;
            number = number >>> 1;
            continue loop;
          }
  done:   ;
          return counter;
}

// Task 1 complete: Tue Oct 24 19:00:03 PDT 2023

// Task 2 complete: Tue Oct 24 19:59:25 PDT 2023
