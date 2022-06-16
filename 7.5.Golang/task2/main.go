package main

import "fmt"

func main() {
	x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
	fmt.Println("Список: ", x)

	fmt.Println("Минимум ", FindMin(x))
}

func FindMin(a []int) int {
    mina := a[0]

    for _, xi := range a {
        if xi < mina {
            mina = xi
        }
    }
    return mina
}

