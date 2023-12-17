# Binary32: The Encoding of the Java float type

## Overview:

In this assignment, you are to develop three versions of a method/subroutine that encodes a real binary number into binary32 format.  This real number can be represented in scientific notation.  For example:

   ```
   + 1.1 0100 1110 0001  x2^  - 10 1001
   ```

Your method/subroutine is provided with four arguments that correspond to the four fields in the number's scientific notation representation.  These four fields are:
   1. the sign of the real number: '+'
   1. the coefficient: "2#1 1 0100 1110 0001"
      - the coefficient represents both the whole number and the mantissa.
      - the coefficient is an integer value provided in fix point.
      - the radix point is set after the first digit from the left. 
   1. the sign of the exponent: '-'
   1. the exponent: 41

Review the file `encode_float.md` that provides the algorithm to convert a binary number, expressed in scientific notation, into binary32. 


## Task 1. Java "encode_binary32.j"

I have provided starter code for you.  This starter code conforms to the algorithm described in the `encode_float.md` document.  I have also provided variable declarations to help you in the development process.


### Prerequisites Task:
  1. Review the starter code.
  1. Ensure you understand the purpose and use of each declared variable.
  1. Execute the starter code, via java_subroutine, and ensure your output is as shown.
     ```bash
     java_subroutine encode_binary32  '+' 0x34E1 '-' 0x29
     #########################################
     # Above is the output from your program
     #########################################
     
     v0:          0; 0x00 00 00 00; 0b0000 0000 0000 0000 0000 0000 0000 0000;
     
     ```
     Note that the given answer is NOT the final correct answer.

### Primary Task:
  1. Continue to edit, commit, and test your program until it is working 100%.

     Remember: the development process is an iterative one.  Hence, you need to perform a number of "edits, test, commits".  When I grade this assignment, the minimal number of required commits will be larger than 6.  How much? A lot.

  1. Four test cases have been provided for you. 
     
     - java_subroutine '-'  2#101011010101 + 101
       * matches the example in `encode_float.md`

     - java_subroutine '-'  11184810 - 42
       * matches the ting, ting, ting, ...

     - java_subroutine '-' 1 '-' 127
       * nothing but zeros

     - java_subroutine '-' 0XFFFFFF '+' 128
       * nothing but ones

  1. You may use `make` to automate the testing of your program.

     * `make`: tests both your Java and MIPS code
     * `make test_java_code`: tests your Java code
     * `make test_mips_code`: tests your MIPS code
     * `make validate`: validates your submission


  1. Review your program one last time 
      - make any appropriate corrections, e.g., formatting changes
      - RE-TEST you code again
      - Commit and Push your final version of your code

      ```bash
      make test_java_code
      git commit -m '{some message}'
      git push
      ```

### Postrequisites Task:

If you program is correct, then you need to perform the following steps.

   ```bash
   make test_java_code
   printf "\n// Task 1 complete: $(date)\n" >> encode_binary32.j
   git commit -m 'Initial Java version complete' encode_binary32.j
   git tag java_version
   git push
   git push --tags
   ```

Caution:  Make sure you program is working 100% before you perform the above steps.  If have to modify your code you will need perform the following tasks:

   ```bash
   make clean
   make test_java_code
   printf "\n// Task 1 complete: $(date)\n" >> encode_binary32.j
   git commit -m 'Initial Java version complete' encode_binary32.j
   git tag --force java_version
   git push
   git push --force --tags
   ```


## Task 2: Java TAC "encode_binary32.j"


### Primary Task:
  1. Rewrite your Java program to follow the TAC convention.
  1. Test your Java program.
  1. Review your program one last time.
     - make any appropriate corrections, e.g., formatting changes
     - RE-TEST you code again
     - Commit and Push your final version of your code

     ```bash
     make clean
     make test_java_code
     git commit -m '{some message}'
     git push
     ```


### Postrequisites Task:

If you program is 100% correct, then you need to perform the following steps.

   ```bash
   printf "\n// Task 2 complete: $(date)\n" >> encode_binary32.j
   git commit -m 'Java TAC complete' encode_binary32.j
   git tag java_tac_version
   git push
   git push --tags
   ```

## Task 3: MIPS "encode_binary32.s"

### Prerequisites Task:
   1. Review the existing file `encode_binary32.s`
      - Read the existing code
      - Locate the "Code of Interest" section of the file

   1. Copy the Java TAC you wrote into the `encode_binary32.s` file.
      - This code gets put into the "Code of Interest" section
   1. Commit your changes to the local repository: `git commit -m "{some message}"`
   1. Push your local repository to the remote repository: `git push`


### Additional Information

   1. The Java "final" variables have been converted to literals within the MIPS file.  
      - For example,
        ```java
        final int bias           = 127;
        ```
        is converted to

        ```mips
        .eqv bias 127
        ```

        and is used within a MIPS instruction as:

        ```mips
        addi $t1, $t1, bias   # Add the bias to $t1
        ```

      - Hence, there is no need to allocate registers to hold these values

   1. The formal arguments of your subroutine have been de-marshaled for you, by placing them into corresponding t-registers.  

      ```mips
      # Demarshal your input arguments
      move $t0, $a0
      move $t1, $a1
      move $t2, $a2
      move $t3, $a3
      ```

   1. To facilitate the call to the pos_msb subroutine, the `call` macro has been created for you.
      - The purpose of this macro will be more fully explained in upcoming lectures

        ```mips
        .macro call(%sub, %arg)
           save_state()
           push($a0)
           move $a0, %arg
           jal %sub
           pop($a0)
           restore_state()
        .end_macro
        ```

      - For now, simply use the translation TAC -> MIPS as provided for 

        | Java TAC                | MIPS Macro                |
        |-------------------------|---------------------------|
        | a = pos_msb(b)          | call pos_msb b            |
        |                         | move a, $v0               |

     

### Primary Task:
  1. Via the transliteration process, modify your "encode_binary32.s" file to be a MIPS subroutine
  1. Test your MIPS program

     ```bash
     make test_java_code
     git commit -m '{some message}'
     git push
     ```

### Postrequisites Task:

If you program is correct, then you need to perform the following steps.

   ```bash
   printf "\n# Task 3 complete: $(date)\n" >> encode_binary32.s
   git commit -m 'MIPS complete' encode_binary32.s
   git tag mips_version
   git push
   git push --tags
   ```

## Task 4: Validation and Final Submission
Prior to your final submission to the repository, run the `make` command to test programs.

If all is working correctly, you can now run the command `make validate`.  This command will create a file called `validation.output`.  Moreover, this file will be added, automatically,  to your repository.


Summary of steps for final submission:

  ```bash
  make validate
  echo >> validation.output
  echo "# Task 4 complete: $(date)" >> validation.output
  git commit -m 'Final Submission' 
  git push     
  ```

You may RESUBMIT your work any number of times prior to the due date.  But you must retag each of your sections.  (See the Caution note above.)