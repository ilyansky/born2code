import Foundation

func printSpaces(_ spaces: Int) {
    for _ in 0...spaces {
        print("\n")
    }
}
var bigHeart = false
let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
    printSpaces(10)
    if bigHeart {
        print("  @@@                     @@@   @@@           @  @@@@")
        print("  @ @   @@ @@                @  @    @@ @@    @  @")
        print("  @@@@  @@@@@  @@@  @@@   @@@   @    @@@@@  @@@  @@@@")
        print("  @  @   @@@   @    @ @  @      @     @@@   @ @  @")
        print("  @@@@    @    @    @ @   @@@   @@@@   @    @@@  @@@@")
    } else {
        print("  @@@                     @@@   @@@           @  @@@@")
        print("  @ @                        @  @             @  @")
        print("  @@@@   @@@   @@@  @@@   @@@   @     @@@   @@@  @@@@")
        print("  @  @   @ @   @    @ @  @      @     @ @   @ @  @")
        print("  @@@@   @@@   @    @ @   @@@   @@@@  @@@   @@@  @@@@")
    }
    bigHeart = !bigHeart
    printSpaces(3)
}

