package main

import (
	"errors"
	"log"
	"net"
	"net/http"
	"os"

	fetchserver "github.com/opensourcecorp/workshops/linux/score-fetcher/pkg/fetch-server"
)

func main() {
	http.HandleFunc("/", fetchserver.Root)

	addr := net.JoinHostPort("0.0.0.0", "8080")
	log.Printf("Starting server on %s\n", addr)

	err := http.ListenAndServe(addr, nil)
	if errors.Is(err, http.ErrServerClosed) {
		log.Println("Server closed")
	} else if err != nil {
		log.Printf("Error starting server: %v\n", err)
		os.Exit(1)
	}
}
