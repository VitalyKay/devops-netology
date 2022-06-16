package main

import (
    "testing"
)

type testpair struct {
    from, to, step int
    list []int
}

var testpairs = []testpair{
    {1, 100, 3, []int{3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99,}},
    {20, 70, 7, []int{21, 28, 35, 42, 49, 56, 63, 70,}},
}

func TestListDel(t *testing.T) {
    for _, pair := range testpairs {
        f := ListDel(pair.from, pair.to, pair.step)
        if !Equal(f, pair.list) {
            t.Error("For values", pair.from, pair.to, pair.step, "expected", pair.list, "got", f)
        }
    }
}

func Equal(a, b []int) bool {
    if len(a) != len(b) {
        return false
    }
    for i, v := range a {
        if v != b[i] {
            return false
        }
    }
    return true
}