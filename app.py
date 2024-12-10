def calculate_fibonacci(n):
    """Calculate the nth Fibonacci number."""
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b

def main():
    result = calculate_fibonacci(10)
    print(f"The 10th Fibonacci number is: {result}")

if __name__ == "__main__":
    main()