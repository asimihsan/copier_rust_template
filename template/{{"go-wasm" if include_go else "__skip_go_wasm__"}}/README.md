# Go WASM Bindings

This directory contains a Go binding for the parser that uses WebAssembly (WASM) with WASI support instead of a native Rust library.

## Features

- Uses WebAssembly (WASM) compiled from Rust code
- Runs in Go using the wazero runtime (zero dependencies)
- Supports WASI for system interfaces (time, etc.)
- Provides the same API as the native Go bindings

## Requirements

- Rust with the wasm32-wasi target installed
- Go 1.21 or newer

## Building

```bash
# Install wasm32-wasi target if needed
just setup

# Build the WASM module
just build-wasm-release

# Run the tests
just test
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
    
    // Parse a single expression
    expr, err := binding.Parse(ctx, "1+2+3")
    if err != nil {
        log.Fatalf("Parse error: %v", err)
    }
    fmt.Println(expr.String()) // Outputs: 1+2+3 = 6
    
    // Use MustParse for expressions you know are valid
    expr2 := binding.MustParse("10+20")
    fmt.Println(expr2.Result) // Outputs: 30
    
    // Parse multiple expressions concurrently
    inputs := []string{"1+2", "3+4", "5+6"}
    results, err := binding.ParseConcurrent(ctx, inputs)
    if err != nil {
        log.Fatalf("ParseConcurrent error: %v", err)
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
