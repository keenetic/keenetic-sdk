// stampcheck reads DNS stamps from standard input, one per line, and says for each
// one whether the stamp parser of dnscrypt-proxy accepts it. It is the reference
// for tests/stamp-parity.js.
//
// It has to be built inside the source tree of dnscrypt-proxy, which vendors the
// parser:
//
//	mkdir <source>/stampcheck
//	cp stampcheck.go <source>/stampcheck/main.go
//	cd <source> && CGO_ENABLED=0 GOFLAGS=-mod=vendor go build -o /tmp/stampcheck ./stampcheck
package main

import (
	"bufio"
	"fmt"
	"os"

	stamps "github.com/jedisct1/go-dnsstamps"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1<<20), 1<<20)
	for scanner.Scan() {
		if _, err := stamps.NewServerStampFromString(scanner.Text()); err != nil {
			fmt.Println("error: " + err.Error())
		} else {
			fmt.Println("ok")
		}
	}
}
