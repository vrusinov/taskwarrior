#! /usr/bin/perl
################################################################################
## taskwarrior - a command line task list manager.
##
## Copyright 2006 - 2011, Paul Beckingham, Federico Hernandez.
## All rights reserved.
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 2 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, write to the
##
##     Free Software Foundation, Inc.,
##     51 Franklin Street, Fifth Floor,
##     Boston, MA
##     02110-1301
##     USA
##
################################################################################

use strict;
use warnings;
use Test::More tests => 4;

# Create the rc file.
if (open my $fh, '>', 'append.rc')
{
  print $fh "data.location=.\n";
  close $fh;
  ok (-r 'append.rc', 'Created append.rc');
}

# Add a task, then append more description.
qx{../src/task rc:append.rc add foo};
qx{../src/task rc:append.rc 1 append bar};
my $output = qx{../src/task rc:append.rc info 1};
like ($output, qr/Description\s+foo\sbar\n/, 'append worked');

# Should cause an error when nothing is appended.
$output = qx{../src/task rc:append.rc 1 append};
unlike ($output, qr/Appended 0 tasks/, 'blank append failed');

# Cleanup.
unlink qw(pending.data completed.data undo.data backlog.data synch.key append.rc);
ok (! -r 'pending.data'   &&
    ! -r 'completed.data' &&
    ! -r 'undo.data'      &&
    ! -r 'backlog.data'   &&
    ! -r 'synch_key.data' &&
    ! -r 'append.rc', 'Cleanup');

exit 0;

