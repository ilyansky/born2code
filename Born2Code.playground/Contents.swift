import Foundation

func printMuchSpace() {
    for _ in 0...10 {
        print("\n")
    }
}
var bigHeart = false
let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
    printMuchSpace()
    if bigHeart {
        print("@@@                     @@@   @@@           @  @@@@")
        print("@ @   @@ @@                @  @    @@ @@    @  @")
        print("@@@@  @@@@@  @@@  @@@   @@@   @    @@@@@  @@@  @@@@")
        print("@  @   @@@   @    @ @  @      @     @@@   @ @  @")
        print("@@@@    @    @    @ @   @@@   @@@@   @    @@@  @@@@")
    } else {
        print("@@@                     @@@   @@@           @  @@@@")
        print("@ @                        @  @             @  @")
        print("@@@@   @@@   @@@  @@@   @@@   @     @@@   @@@  @@@@")
        print("@  @   @ @   @    @ @  @      @     @ @   @ @  @")
        print("@@@@   @@@   @    @ @   @@@   @@@@  @@@   @@@  @@@@")
    }
    bigHeart = !bigHeart
}

