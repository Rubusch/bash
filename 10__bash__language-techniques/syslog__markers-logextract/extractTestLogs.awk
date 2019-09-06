BEGIN {
  copyMode = 0;
}

{
  copyEndString = 0;
  startstring = "Testsuite1234567" testsuite " started"
  if ( match($0, startstring) > 0 ) {
    copyMode = 1;
  }
  endstring = "Testsuite1234567" testsuite " ended"
  if ( match($0, endstring) > 0 ) {
    copyMode = 0;
    copyEndString = 1;
  }
  if ( copyMode || copyEndString ) {
    print $0
  }
}

END {
}

