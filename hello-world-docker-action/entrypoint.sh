#!/bin/sh -l

echo "You're my $1"
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT

