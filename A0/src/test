#!/usr/bin/env bash

# Exit immediately if any command below fails.
set -e 

make

echo "Generating a test_files directory.."
mkdir -p test_files
rm -f test_files/*


echo "Generating test files.."
printf "Hello, World!\n" > test_files/ascii.input ## ascii file
printf "Hello, World!" > test_files/ascii2.input ## another ascii file, with nl char
printf "Hello,\x00World!\n" > test_files/data.input ## file containing a char outside our ascii-text definition
printf "" > test_files/empty.input	## empty file
printf "Secret file" > test_files/secret.input && chmod -r test_files/secret.input ## make secret file
printf "scale=4000; 4*a(1)" | bc -l > test_files/large_ascii.input ## generates a file containing pi with an amount of digits equal to the "scale" value (ascii)
printf "scale=4000; 4*a(1)" | bc -l > test_files/large_ascii.input  && printf "\372 ">> test_files/large_non_ascii.input ## adds the "u acute" character to the end of a large ascii file
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


chmod +r test_files/secret.input ## make secret file not secret again, so we are able to commit file in git 

exit $exitcode
