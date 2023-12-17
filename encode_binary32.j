public static int encode_binary32(int sign, int coefficient, int expon_sign, int exponent){
           
            int encoding; // : return value

            int encoded_sign; 
            int encoded_mantissa; 
            int encoded_exponent; 
            int position; // the location of the msb of the coefficient
            int coefficient_shift; 
            int negative_sign = '-';     // Define the value 

            final int bias = 127;  // bias: As defined by the spec
            final int sign_shift =  31;  // sign_shift:  << (8 + 23 )
            final int expon_shift =  23;  // expon_shift:  << (23)
            final int mantissa_shift =   7;  // mantissa_shift: >>> (8 - 1)  // the mantissa is left-justified
           

            if (sign == negative_sign) {
              encoded_sign = 1;
            }
            else {
            
              encoded_sign = 0;
            }
            if (expon_sign == negative_sign) {             
              encoded_exponent= -(exponent);
              encoded_exponent += bias;
            }
            else{
              encoded_exponent = exponent;
              encoded_exponent += bias;
            }          
            position = pos_msb(coefficient);
            position = sign_shift - position;
            coefficient_shift = coefficient << position; //using sign shift because it is 32 bits
            encoded_mantissa = coefficient_shift;
            encoded_sign = encoded_sign << sign_shift;
            encoded_exponent = encoded_exponent << expon_shift;
            encoded_mantissa = encoded_mantissa >>> mantissa_shift;
            encoded_mantissa = encoded_mantissa & 0x7FFFFF;    // 0x7FFFFF is 23, the size of the mantissa          
            encoding = encoded_sign | encoded_exponent | encoded_mantissa;
            return encoding;
  }

static int pos_msb(int number){
          int counter = 0;

          while(number != 0) {
            counter ++;
            number = number >>> 1;
          }
          return counter;
}