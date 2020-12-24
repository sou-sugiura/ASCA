#!/bin/sh

##Initialization
rm -f top
rm -f func3_test

##Compile Design
iverilog \
    -o top \
    -s func3_test \
    -f rtl/vlist.f \
    -f tb/tblist.f \
    > LOG/compile.log

##Simulation
vvp top > LOG/simulation.log

##Activate Wave Viewer
gtkwave func3_test.vcd > LOG/wave.log
