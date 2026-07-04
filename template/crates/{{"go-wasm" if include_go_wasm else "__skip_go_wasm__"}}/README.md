# Go WASM Bindings

This directory contains a Go binding for the greeting API that uses WebAssembly (WASM)
with WASI support instead of a native Rust library.

## Features

- Uses WebAssembly (WASM) compiled from Rust code
- Runs in Go using the wazero runtime (zero dependencies)
- Supports WASI for system interfaces (time, etc.)
- Provides the same API as the native Go bindings

## Requirements

- Rust with the `wasm32-wasip1` target installed
- Go 1.26.1 or newer

## Building

```bash
# Install wasm32-wasip1 target if needed
mise run go-wasm:setup

# Build the WASM module
mise run go-wasm:build-wasm-release

# Run the tests
mise run go-wasm:test
```

## Usage

```go
package main

import (
    "context"
    "fmt"
    "log"

    "github.com/ab/cd/go-wasm/go/binding"
)

func main() {
    ctx := context.Background()
    
    // Greet a single recipient
    greeting, err := binding.Greet(ctx, "Ihsan")
    if err != nil {
        log.Fatalf("Greet error: %v", err)
    }
    fmt.Println(greeting.String())
    
    // Use MustGreet for recipients you know are valid
    greeting2 := binding.MustGreet("Rust")
    fmt.Println(greeting2.Message)
    
    // Greet multiple recipients concurrently
    recipients := []string{"Ihsan", "Rust", "WASI"}
    results, err := binding.GreetConcurrent(ctx, recipients)
    if err != nil {
        log.Fatalf("GreetConcurrent error: %v", err)
    }
    
    for _, result := range results {
        fmt.Println(result.String())
    }
    
    // Get timestamp from the WASM module (uses WASI)
    timestamp, err := binding.GetWasmTimestamp(ctx)
    if err != nil {
        log.Fatalf("GetWasmTimestamp error: %v", err)
    }
    fmt.Println("WASM Timestamp:", timestamp)
    
    // Clean up when done
    binding.Close(ctx)
}
```

## How It Works

1. Rust code is compiled to WebAssembly with WASI support
2. The Go binding uses wazero to load and execute the WASM module
3. Memory management is handled through exported functions
4. The API matches the native Go bindings for ease of use

## Benefits Over Native Bindings

- No need for CGO or native library compilation
- Portable across all platforms supported by Go
- Isolated execution in a sandboxed environment
- Easier deployment without platform-specific binaries
