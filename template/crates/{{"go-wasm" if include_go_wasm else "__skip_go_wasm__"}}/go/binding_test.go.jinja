package binding

import (
	"context"
	"sync"
	"testing"
	"time"
)

func TestGreet(t *testing.T) {
	ctx := context.Background()
	greeting, err := Greet(ctx, "Ihsan")
	if err != nil {
		t.Fatalf("Greet failed: %v", err)
	}

	expected := "Hello, Ihsan! Welcome to {{ project_name }}."
	if greeting.Message != expected {
		t.Errorf("expected %q, got %q", expected, greeting.Message)
	}

	if greeting.Recipient != "Ihsan" {
		t.Errorf("expected recipient Ihsan, got %q", greeting.Recipient)
	}
}

func TestGreetError(t *testing.T) {
	ctx := context.Background()
	_, err := Greet(ctx, "")
	if err == nil {
		t.Fatal("expected error, got nil")
	}
}

func TestMustGreet(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Error("MustGreet with invalid input did not panic")
		}
	}()

	greeting := MustGreet("Rust")
	expected := "Hello, Rust! Welcome to {{ project_name }}."
	if greeting.Message != expected {
		t.Errorf("expected %q, got %q", expected, greeting.Message)
	}

	MustGreet("")
}

func TestGreetConcurrent(t *testing.T) {
	ctx := context.Background()
	recipients := []string{"Ihsan", "Rust", "WASI"}
	results, err := GreetConcurrent(ctx, recipients)
	if err != nil {
		t.Fatalf("GreetConcurrent failed: %v", err)
	}

	for i, result := range results {
		expected := "Hello, " + recipients[i] + "! Welcome to {{ project_name }}."
		if result.Message != expected {
			t.Errorf("expected %q, got %q", expected, result.Message)
		}
	}
}

func TestGreetConcurrentWithError(t *testing.T) {
	ctx := context.Background()
	recipients := []string{"Ihsan", "", "Rust"}
	results, err := GreetConcurrent(ctx, recipients)
	if err == nil {
		t.Fatal("expected error, got nil")
	}

	if results[0] == nil || results[0].Recipient != "Ihsan" {
		t.Errorf("expected first result for Ihsan, got %#v", results[0])
	}

	if results[2] == nil || results[2].Recipient != "Rust" {
		t.Errorf("expected third result for Rust, got %#v", results[2])
	}
}

func TestContextCancellation(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel()

	_, err := Greet(ctx, "Ihsan")
	if err == nil || err != context.Canceled {
		t.Fatalf("expected context.Canceled error, got %v", err)
	}
}

func TestHighConcurrency(t *testing.T) {
	ctx := context.Background()
	count := 50

	var wg sync.WaitGroup
	errChan := make(chan error, count)

	for i := 0; i < count; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()

			recipient := []string{"Ihsan", "Rust", "WASI", "Go"}[idx%4]
			greeting, err := Greet(ctx, recipient)
			if err != nil {
				errChan <- err
				return
			}

			expected := "Hello, " + recipient + "! Welcome to {{ project_name }}."
			if greeting.Message != expected {
				errChan <- &GreetingError{msg: "incorrect greeting"}
			}
		}(i)
	}

	wg.Wait()
	close(errChan)

	for err := range errChan {
		t.Fatalf("concurrent greeting failed: %v", err)
	}
}

func TestGetWasmTimestamp(t *testing.T) {
	ctx := context.Background()
	wasmTime, err := GetWasmTimestamp(ctx)
	if err != nil {
		t.Fatalf("GetWasmTimestamp failed: %v", err)
	}

	diff := time.Since(wasmTime)
	if diff < 0 {
		diff = -diff
	}

	if diff > 2*time.Second {
		t.Errorf("time difference too large: %v", diff)
	}
}

func TestConcurrentMemoryCleanup(t *testing.T) {
	ctx := context.Background()

	for iter := 0; iter < 10; iter++ {
		var wg sync.WaitGroup
		for i := 0; i < 50; i++ {
			wg.Add(1)
			go func(idx int) {
				defer wg.Done()
				recipient := []string{"Ihsan", "Rust", "WASI", "Go"}[idx%4]
				_, _ = Greet(ctx, recipient)
			}(i)
		}
		wg.Wait()
	}
}
