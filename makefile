COMMITS=$(shell git log --oneline | wc -l)
MIN_COMMITS=12

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

validate: $(SRC) tags number_commits
	-make -k  all > validation.output 2>&1
	-git add validation.output
	-git commit -m 'Auto adding validation step' validation.output
	@echo Validation File has been committed if there were changes


# Currently, the number of commits does not work on the server side
# the log file only shows the most recent entry -- 
# not sure why or what the work around is.
number_commits:
	@-test ! $(COMMITS) -lt $(MIN_COMMITS) || \
	  { echo "Not enough commits" && false ; } 

tags:
	@-git tag | grep -q -e "java_version"      || echo "Missing java_version tag"
	@-git tag | grep -q -e "java_tac_version"  || echo "Missing java_tac_version tag"
	@-git tag | grep -q -e "mips_version"      || echo "Missing mips_version tag"


clean:
	-rm -f test_java_code
	-rm -f test_mips_code


