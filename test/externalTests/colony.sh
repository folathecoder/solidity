#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2019 solidity contributors.
#------------------------------------------------------------------------------

set -e

source scripts/common.sh
source test/externalTests/common.sh

verify_input "$1"
SOLJSON="$1"

function install_fn { yarn; git submodule update --init; }
function compile_fn { yarn run provision:token:contracts; }
function test_fn { yarn run test:contracts; }

function colony_test
{
    OPTIMIZER_LEVEL=3
    CONFIG="truffle.js"

    truffle_setup "$SOLJSON" https://github.com/solidity-external-tests/colonyNetwork.git develop_080
    run_install "$SOLJSON" install_fn

    cd lib
    rm -Rf dappsys
    git clone https://github.com/solidity-external-tests/dappsys-monolithic.git -b master_080 dappsys
    cd ..

    truffle_run_test "$SOLJSON" compile_fn test_fn
}

external_test ColonyNetworks colony_test
