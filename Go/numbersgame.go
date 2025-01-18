package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    // Seed the random number generator
    rand.Seed(time.Now().UnixNano())

    // Generate a random number between 1 and 100
    target := rand.Intn(100) + 1

    var guess int
    var attempts int

    fmt.Println("Welcome to the Number Guessing Game!")
    fmt.Println("I have selected a random number between 1 and 100.")
    fmt.Println("Can you guess what it is?")

    for {
        fmt.Print("Enter your guess: ")
        fmt.Scan(&guess)
        attempts++

        if guess < target {
            fmt.Println("Too low! Try again.")
        } else if guess > target {
            fmt.Println("Too high! Try again.")
        } else {
            fmt.Printf("Congratulations! You guessed the number in %d attempts.\n", attempts)
            break
        }
    }
}