// Copyright 2018 The dpeth Authors
// This file is part of the dpeth library.
//
// The dpeth library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The dpeth library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the dpeth library. If not, see <http://www.gnu.org/licenses/>.

// PM want to change the prefix of hex from 0x to anything they want, @#$%@#$%@#%^ ;-)
// Just set the CustomHashPrefix to "0x" , everything will back to normal.

package hexutil

// still use 0x, to avoid some wallet abnormal use.
// still can support c0 prefix address
const CustomHexPrefix = "0x"

var PossibleCustomHexPrefixMap = map[string]bool{
	"0x": true,
	"0X": true,
	"c0": true,
	"c1": true,
	"c2": true,
	"c3": true,
	"c4": true,
	"c5": true,
	"c6": true,
	"c7": true,
	"c8": true,
	"c9": true,
	"C0": true,
	"C1": true,
	"C2": true,
	"C3": true,
	"C4": true,
	"C5": true,
	"C6": true,
	"C7": true,
	"C8": true,
	"C9": true,
}

func CPToHex(s string) string {
	if len(s) > len(CustomHexPrefix) {
		if _, ok := PossibleCustomHexPrefixMap[s[:2]]; ok {
			return "0x" + s[2:]
		}
	}
	return s
}

func HexToCP(s string) string {
	if len(s) > 2 {
		if s[:2] == "0x" || s[:2] == "0X" {
			return CustomHexPrefix + s[2:]
		}
	}
	return s
}
