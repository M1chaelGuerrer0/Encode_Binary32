SRC=encode_binary32.j encode_binary32.s


TEST_CASE1='-'  "2\#101011010101" + 101
RESULT1="0xF2 2D 50 00"

#java_subroutine '+' 0x34E1 '-' 0x29
TEST_CASE2='-'  11184810 - 42
RESULT2="0xAA AA AA AA"

#java_subroutine '+' 0x0001 '-' 127   # result 0x00000000
TEST_CASE3='+' 0x0001 '-' 127
RESULT3="0x00 00 00 00"


#java_subroutine '-' 0XFFFFFF '+' 128   # result all ones
TEST_CASE4='-' 0XFFFFFF '+' 128 
RESULT4="0xFF FF FF FF"


all: test_java_code test_mips_code

test_java_code: encode_binary32.j
	java_subroutine encode_binary32 $(TEST_CASE1)
	@echo "Correct answer: " $(RESULT1)
	@echo
	java_subroutine encode_binary32 $(TEST_CASE2)
	@echo "Correct answer: " $(RESULT2)
	@echo
	java_subroutine encode_binary32 $(TEST_CASE3)
	@echo "Correct answer: " $(RESULT3)
	@echo
	java_subroutine encode_binary32 $(TEST_CASE4)
	@echo "Correct answer: " $(RESULT4)
	@echo

test_mips_code: encode_binary32.s
	mips_subroutine encode_binary32 $(TEST_CASE1)
	@echo "Correct answer: " $(RESULT1)
	@echo
	mips_subroutine encode_binary32 $(TEST_CASE2)
	@echo "Correct answer: " $(RESULT2)
	@echo
	mips_subroutine encode_binary32 $(TEST_CASE3)
	@echo "Correct answer: " $(RESULT3)
	@echo
	mips_subroutine encode_binary32 $(TEST_CASE4)
	@echo "Correct answer: " $(RESULT4)
	@echo


clean:
	-rm -f test_java_code
	-rm -f test_mips_code
