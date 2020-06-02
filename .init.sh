#!/bin/sh

if [ ! -d /root/.dpeth/dpeth/chaindata ] ; then
    cp -r /root/.block0/* /root/.dpeth/
fi