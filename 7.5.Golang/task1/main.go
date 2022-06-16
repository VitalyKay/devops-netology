package main

import "fmt"

func main() {
	fmt.Println("Введите величину в метрах:")
	var mlen float64
	fmt.Scanf("%f", &mlen)

    flen := Meter2Foot(mlen)

	fmt.Printf("%f футов\n", flen)
}

func Meter2Foot(meters float64) float64 {
    return meters/0.3048
}