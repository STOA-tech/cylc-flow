#!/bin/bash
# THIS FILE IS PART OF THE CYLC SUITE ENGINE.
# Copyright (C) 2008-2019 NIWA & British Crown (Met Office) & Contributors.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Test validation fails '&&' and '||' in the graph.
. $(dirname $0)/test_header
#-------------------------------------------------------------------------------
set_test_number 8
#-------------------------------------------------------------------------------
cat > suite.rc <<__END__
[scheduling]
    [[graph]]
        R1 = foo && bar => baz
__END__
#-------------------------------------------------------------------------------
TEST_NAME=${TEST_NAME_BASE}-async-and
run_fail $TEST_NAME cylc validate -v suite.rc
grep_ok "GraphParseError: the graph AND operator is '&': " $TEST_NAME.stderr
#-------------------------------------------------------------------------------
TEST_NAME=${TEST_NAME_BASE}-async-or
sed -i -e 's/&&/||/' suite.rc
run_fail $TEST_NAME cylc validate -v suite.rc
grep_ok "GraphParseError: the graph OR operator is '|': " $TEST_NAME.stderr
#-------------------------------------------------------------------------------
cat > suite.rc <<__END__
[scheduling]
    initial cycle point = 2015
    [[graph]]
        R1 = foo && bar => baz
__END__
#-------------------------------------------------------------------------------
TEST_NAME=${TEST_NAME_BASE}-cycling-and
run_fail $TEST_NAME cylc validate -v suite.rc
grep_ok "GraphParseError: the graph AND operator is '&': " $TEST_NAME.stderr
#-------------------------------------------------------------------------------
TEST_NAME=${TEST_NAME_BASE}-cycling-or
sed -i -e 's/&&/||/' suite.rc
run_fail $TEST_NAME cylc validate -v suite.rc
grep_ok "GraphParseError: the graph OR operator is '|': " $TEST_NAME.stderr
