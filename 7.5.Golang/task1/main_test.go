package main

import (
    "testing"
    "math"
)

type testpair struct {
    meter, foot float64
}

var testpairs = []testpair{
    {3, 9.842519685},
    {5, 16.404199475},
    {7, 22.965879265},
}

func TestMeter2Foot(t *testing.T) {
    for _, pair := range testpairs {
        f := math.Round(Meter2Foot(pair.meter)*1000000000)/1000000000
        if f != pair.foot {
            t.Error("For ", pair.meter, " expected ", pair.foot, " got ", f)
        }
    }
}