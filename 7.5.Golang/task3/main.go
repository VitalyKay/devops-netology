package main

import "fmt"

func main() {
	fmt.Println("Список чисел от 1 до 100, делящихся на 3: ", ListDel(20, 70, 7))
}

func ListDel(from, to, del int) []int {
    var x []int
    for i := from; i <= to; i++ {
        if i%del == 0 {
            x = append(x, i)
	    }
    }
    return x
}

