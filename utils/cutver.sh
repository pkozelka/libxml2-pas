#!/bin/sh
# Cuts the version out of the include file. A specific formating is required.
# Petr Kozelka (C) 2002

grep "_DOTTED_VERSION = '" $1 | cut -d\' -f2
