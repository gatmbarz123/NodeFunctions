import unittest
from app import calculate_fibonacci

class TestFibonacci(unittest.TestCase):
    def test_fibonacci_zero(self):
        self.assertEqual(calculate_fibonacci(0), 0)
    
    def test_fibonacci_one(self):
        self.assertEqual(calculate_fibonacci(1), 1)
    
    def test_fibonacci_ten(self):
        self.assertEqual(calculate_fibonacci(10), 55)

if __name__ == '__main__':
    unittest.main()