package main

import (
    "testing"
)

type testpair struct {
    list []int
    min int
}

var testpairs = []testpair{
    {[]int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}, 9},
    {[]int{54,77,23,13,44,89,71,15,33,68,46,51,49,92,28,64,}, 13},
}

func TestFindMin(t *testing.T) {
    for _, pair := range testpairs {
        f := FindMin(pair.list)
        if f != pair.min {
            t.Error("For", pair.list, "expected ", pair.min, " got ", f)
        }
    }
}