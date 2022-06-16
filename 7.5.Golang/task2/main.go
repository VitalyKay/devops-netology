package main

import "fmt"

func main() {
	x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
	fmt.Println("Список: ", x)
	minx := x[0]
	mini := 0

	for i, xi := range x {
	    if xi < minx {
	        minx = xi
	        mini = i
	    }
	}

	fmt.Printf("Минимум %d , индекс %d\n", minx, mini)
}


