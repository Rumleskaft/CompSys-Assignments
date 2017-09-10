#!/usr/bin/env bash

# Exit immediately if any command below fails.
set -e 

make

echo "Generating a test_files directory.."
mkdir -p test_files
rm -f test_files/*


echo "Generating test files.."

## Ascii files

printf "Hello, World!\n" > test_files/ascii.input ## ascii file
printf "Hello, World!" > test_files/ascii2.input ## another ascii file, with nl char
printf "scale=4000; 4*a(1)" | bc -l > test_files/large_ascii.input ## generates a file containing pi with an amount of digits equal to the "scale" value (ascii)

## Generates 12 random ascii files for testing (alphanumeric chars only)

max=11
for i in `seq 0 $max`
do 
  filename="test_files/random_ascii_${i}.input"
  base64 /dev/urandom | head -c $(( 5**i )) > $filename # generates 12 random ascii files
done

## Data files (Non-ascii files)
printf "Hello,\x00World!\n" > test_files/data.input ## file containing a char outside our ascii-text definition
printf "scale=4000; 4*a(1)" | bc -l > test_files/large_non_ascii.input  && printf "\372 ">> test_files/large_non_ascii.input ## adds the "u acute" character to the end of a large ascii file


## Generates 12 random non-ascii files for testing
## base idea from https://stackoverflow.com/questions/3598622/is-there-a-command-to-write-random-garbage-bytes-into-a-file

max=12
for i in `seq 1 $max`
do 
	filename="test_files/random_non_ascii_${i}.input"
	shred -s $(( 5**i )) -> $filename # generates 12 random non-ascii files


done


## Empty files
echo "" > test_files/empty_echo.input		## empty file but with newline from echo (1 byte)
printf "" > test_files/empty_string.input	## empty string in file (is 0 bytes)
touch test_files/empty.input			## empty file (is 0 bytes)
cat /dev/null > test_files/empty_cat.input	## empty file (is 0 bytes)


## IO Error files
printf "Secret file" > test_files/secret.input && chmod -r test_files/secret.input ## make secret file


echo "Running the tests.."
exitcode=0
for f in test_files/*.input
do
  echo ">>> Testing ${f}.."
  file    "${f}" | sed 's/ASCII text.*/ASCII text/' > "${f}.expected"
  ./file  "${f}" > "${f}.actual"

  if ! diff -u "${f}.expected" "${f}.actual"
  then
    echo ">>> Failed :-("
    exitcode=1
  else
    echo ">>> Success :-)"
  fi
done


## test non-existing file
test="test_files/does_not_exist.input"
echo ">>> Testing ${test}.."
  file    "${test}" | sed 's/ASCII text.*/ASCII text/' > "${test}.expected"
  ./file  "${test}" > "${test}.actual"

  if ! diff -u "${test}.expected" "${test}.actual"
  then
    echo ">>> Failed :-("
    exitcode=1
  else
    echo ">>> Success :-)"
  fi


chmod +r test_files/secret.input ## make secret file not secret again, so we are able to commit file in git 

exit $exitcode
