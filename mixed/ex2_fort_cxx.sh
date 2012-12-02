#!/bin/bash
#
#  Compile the FORTRAN file.
#
#  The "nounderscore" option keeps the FORTRAN compiler from adding underscores
#  to the names of the compiled routines.
#
fort -c -assume nounderscore ex2_main.f90 >& compiler.txt
if [ $? -ne 0 ]; then
  echo "Errors compiling ex2_main.f90"
  exit
fi
rm compiler.txt
#
#  Compile the C++ file.
#  Every routine in the file that is to be accessed by a FORTRAN routine must be
#  declared with the "extern "C" {}" property, so that the C++ compiler doesn't
#  do weird things to the names.
#
cxx -c ex2_sub.cpp >& compiler.txt
if [ $? -ne 0 ]; then
  echo "Errors compiling ex2_sub.cpp"
  exit
fi
rm compiler.txt
#
#  I couldn't figure out what the C++ libraries were called, so I figured
#  I'd use the CC command to load the object code, and include the FORTRAN 90
#  libraries explicitly.  But then, you MUST be sure that the FORTRAN90 main
#  program is called "main"!
#
#  Hey, isn't this easy?
#
#fort ex2_main.o ex2_sub.o -lc -lm
cxx ex2_main.o ex2_sub.o -lfor
if [ $? -ne 0 ]; then
  echo "Errors linking and loading ex2_main.o + ex2_sub.o"
  exit
fi
#
mv a.out ex2_fort_cxx
rm *.o
#
#  Run the program.
#
ex2_fort_cxx > ex2_fort_cxx_output.txt
if [ $? -ne 0 ]; then
  echo "Errors running ex2_fort_cxx."
  exit
fi
rm ex2_fort_cxx
#
echo "Program output written to ex2_fort_cxx_output.txt"
