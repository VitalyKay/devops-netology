package main

import "fmt"

func main() {
	fmt.Println("Введите величину в метрах:")
	var mlen float64
	fmt.Scanf("%f", &mlen)

    flen := mlen/0.3048

	fmt.Printf("%f футов\n", flen)
}
