import numpy as np

def calculate_function(x: float) -> float:
    """
    Calculate F(x) = -a₀ + a₁x + a₂x² - a₃x³
    where a₀ = 0.6768, a₁ = 0.144, a₂ = 0.47, a₃ = 0.1
    
    This function is used to find where F(x) crosses zero.
    """
    return -0.6768 + 0.144 * x + 0.47 * x**2 - 0.1 * x**3

def iteration_function(x: float) -> float:
    """
    Calculate the iteration function f(x) = x + F(x)
    This is the function used in the successive approximations method.
    """
    return x - 0.6768 + 0.144 * x + 0.47 * x**2 - 0.1 * x**3

def derivative_function(x: float) -> float:
    """
    Calculate f'(x) = 1 + a₁ + 2a₂x - 3a₃x²
    Used to check convergence conditions.
    """
    return 1 + 0.144 + 2 * 0.47 * x - 3 * 0.1 * x**2

def find_initial_roots(start: float = -5, end: float = 4, step: float = 1) -> list:
    """
    Find initial approximations by looking for sign changes in F(x).
    
    Args:
        start: Starting point for search
        end: Ending point for search
        step: Step size for search
    
    Returns:
        List of initial approximations where F(x) changes sign
    """
    initial_roots = []
    
    for x in np.arange(start, end, step):
        y1 = calculate_function(x)
        y2 = calculate_function(x + step)
        
        # If signs are different, we found a root
        if y1 * y2 < 0:
            initial_root = (2 * x + step) / 2
            initial_roots.append(initial_root)
            
            if len(initial_roots) >= 3:  # We only need 3 roots
                break
                
    return initial_roots

def successive_approximation(x0: float, epsilon: float = 0.0001) -> tuple:
    """
    Implement the method of successive approximations.
    
    Args:
        x0: Initial approximation
        epsilon: Desired accuracy
    
    Returns:
        tuple: (iterations list, convergence status)
    """
    iterations = []
    x_current = x0
    
    while True:
        x_next = iteration_function(x_current)
        iterations.append((x_current, x_next, abs(x_next - x_current)))
        
        # Check convergence condition
        if abs(x_next - x_current) < epsilon:
            return iterations, True
            
        # Check if method diverges
        if abs(derivative_function(x_next)) > 1:
            return iterations, False
            
        x_current = x_next

def print_results(roots: list, selected_root_index: int = 1, epsilon: float = 0.0001):
    """
    Print the results in a formatted table, similar to the C program output.
    """
    print("\nMethod of Successive Approximations\n")
    
    # Print initial roots table
    print("-" * 41)
    print("|    x1     |      x2      |    x3      |")
    print("-" * 41)
    print("|  {:.4f}  |  {:.4f}    |  {:.4f}    |".format(*roots))
    print("-" * 41)
    
    # Perform successive approximation for selected root
    print(f"\nResults for root {selected_root_index + 1}  x0={roots[selected_root_index]:.1f}\n")
    print("-" * 41)
    print("| № |    xi    |   xi+1   | abs(xi+1-xi)|")
    print("-" * 41)
    
    iterations, converged = successive_approximation(roots[selected_root_index], epsilon)
    
    for i, (x_current, x_next, diff) in enumerate(iterations, 1):
        print("|{:2d}.| {:.5f} |  {:.5f}  |  {:.5f}  |".format(
            i, x_current, x_next, diff))
    
    if not converged:
        print("\nMethod diverges.\n")
    else:
        print("-" * 41)

def main():
    # Find initial approximations
    roots = find_initial_roots()
    
    if len(roots) < 3:
        print("Program cannot continue as the required number of roots was not found.")
        return
    
    # Print results using the second root (index 1)
    print_results(roots)

if __name__ == "__main__":
    main()
