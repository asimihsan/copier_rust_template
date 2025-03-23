package binding

import (
	"context"
	"sync"
	"testing"
	"time"
)

// TestParse tests the basic parsing functionality
func TestParse(t *testing.T) {
	ctx := context.Background()
	expr, err := Parse(ctx, "1+2")
	
	if err != nil {
		t.Fatalf("Parse failed: %v", err)
	}
	
	if expr.Result != "3" {
		t.Errorf("Expected result '3', got '%s'", expr.Result)
	}
	
	if expr.Raw != "1+2" {
		t.Errorf("Expected raw '1+2', got '%s'", expr.Raw)
	}
}

// TestParseError tests error handling
func TestParseError(t *testing.T) {
	ctx := context.Background()
	_, err := Parse(ctx, "1+")
	
	if err == nil {
		t.Fatal("Expected error, got nil")
	}
}

// TestMustParse tests the MustParse function
func TestMustParse(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Error("MustParse with invalid input did not panic")
		}
	}()
	
	// This should work
	expr := MustParse("1+2")
	if expr.Result != "3" {
		t.Errorf("Expected result '3', got '%s'", expr.Result)
	}
	
	// This should panic
	MustParse("1+")
}

// TestParseConcurrent tests concurrent parsing
func TestParseConcurrent(t *testing.T) {
	ctx := context.Background()
	inputs := []string{"1+2", "3+4", "5+6"}
	
	results, err := ParseConcurrent(ctx, inputs)
	if err != nil {
		t.Fatalf("ParseConcurrent failed: %v", err)
	}
	
	expectedResults := []string{"3", "7", "11"}
	for i, result := range results {
		if result.Result != expectedResults[i] {
			t.Errorf("Expected result '%s', got '%s'", expectedResults[i], result.Result)
		}
	}
}

// TestParseConcurrentWithError tests concurrent parsing with errors
func TestParseConcurrentWithError(t *testing.T) {
	ctx := context.Background()
	inputs := []string{"1+2", "invalid", "5+6"}
	
	results, err := ParseConcurrent(ctx, inputs)
	
	// We should get an error
	if err == nil {
		t.Fatal("Expected error, got nil")
	}
	
	// But still get valid results for the valid inputs
	if results[0] == nil || results[0].Result != "3" {
		t.Errorf("Expected first result '3', got %v", results[0])
	}
	
	if results[2] == nil || results[2].Result != "11" {
		t.Errorf("Expected third result '11', got %v", results[2])
	}
}

// TestContextCancellation tests that parsing respects context cancellation
func TestContextCancellation(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel() // Cancel immediately
	
	_, err := Parse(ctx, "1+2")
	if err == nil || err != context.Canceled {
		t.Fatalf("Expected context.Canceled error, got %v", err)
	}
}

// TestHighConcurrency tests parsing with a high number of concurrent calls
func TestHighConcurrency(t *testing.T) {
	ctx := context.Background()
	count := 50 // Reduced from 100 to avoid resource exhaustion
	
	var wg sync.WaitGroup
	errChan := make(chan error, count)
	
	// Launch many concurrent parsing operations
	for i := 0; i < count; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			
			// Mix of different expressions to exercise the code
			input := ""
			expected := ""
			
			switch idx % 4 {
			case 0:
				input = "1+2"
				expected = "3"
			case 1:
				input = "10+5"
				expected = "15"
			case 2:
				input = "3+4"
				expected = "7" 
			case 3:
				input = "8+2"
				expected = "10"
			}
			
			expr, err := Parse(ctx, input)
			if err != nil {
				errChan <- err
				return
			}
			
			if expr.Result != expected {
				errChan <- &ParseError{msg: "incorrect result"}
				return
			}
		}(i)
	}
	
	// Wait for all operations to complete
	wg.Wait()
	close(errChan)
	
	// Check for errors
	var errors []error
	for err := range errChan {
		errors = append(errors, err)
	}
	
	if len(errors) > 0 {
		t.Errorf("Got %d errors in concurrent operations, first error: %v", len(errors), errors[0])
	}
}

// TestGetWasmTimestamp tests the WASI time functionality
func TestGetWasmTimestamp(t *testing.T) {
	ctx := context.Background()
	
	// Get the timestamp from WASM
	wasmTime, err := GetWasmTimestamp(ctx)
	if err != nil {
		t.Fatalf("GetWasmTimestamp failed: %v", err)
	}
	
	// Get the current time in Go
	goTime := time.Now()
	
	// The times should be close (within a reasonable margin)
	diff := goTime.Sub(wasmTime)
	if diff < 0 {
		diff = -diff
	}
	
	// Allow for up to 2 seconds difference (generous to avoid flaky tests)
	if diff > 2*time.Second {
		t.Errorf("Time difference too large: %v", diff)
	}
}

// TestConcurrentMemoryCleanup tests that memory is properly released even under concurrent load
func TestConcurrentMemoryCleanup(t *testing.T) {
	// This is a stress test to ensure memory doesn't leak
	// We can't directly check if memory is freed, but if the code is correct,
	// this should run without crashes or hangs
	
	ctx := context.Background()
	count := 50
	iterations := 10
	
	for iter := 0; iter < iterations; iter++ {
		var wg sync.WaitGroup
		
		// Launch many concurrent parsing operations
		for i := 0; i < count; i++ {
			wg.Add(1)
			go func() {
				defer wg.Done()
				
				// Parse a variety of expressions
				inputs := []string{
					"1+2",
					"3*4",
					"10-5",
					"20/4",
					"(2+3)*4",
					"1+2+3+4+5",
				}
				
				for _, input := range inputs {
					_, _ = Parse(ctx, input)
				}
			}()
		}
		
		wg.Wait()
	}
	
	// If we made it here without crashes or hangs, the test passes
}
