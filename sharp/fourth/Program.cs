#pragma warning disable 9107

using System.Diagnostics;

namespace fourth;

interface IQuadraticDiscriminant
{
    double Discriminant { get; }
}

interface IQuadraticRoots
{
    double FirstRoot { get; }
    double SecondRoot { get; }
    void CalculateRoots();
}

class QuadraticDiscriminant(double a, double b, double c) : IQuadraticDiscriminant
{
    public double Discriminant => b * b - 4 * a * c;
}

class QuadraticRoots(double a, double b, double c) : QuadraticDiscriminant(a, b, c), IQuadraticRoots
{
    public double FirstRoot { get; private set; }
    public double SecondRoot { get; private set; }

    public void CalculateRoots()
    {
        double discriminant = Discriminant;
        if (discriminant > 0)
        {
            FirstRoot = (-b + Math.Sqrt(discriminant)) / (2 * a);
            SecondRoot = (-b - Math.Sqrt(discriminant)) / (2 * a);
        }
        else if (discriminant == 0)
        {
            FirstRoot = SecondRoot = -b / (2 * a);
        }
        else
        {
            throw new Exception("impossible to calculate roots");
        }
    }
}

class QuadraticEquation(double a, double b, double c) : QuadraticRoots(a, b, c)
{
    public void PrintCalculated()
    {
        string message = $"A = {a}, B = {b}, C = {c};\nD = {Discriminant};\nR1 = {FirstRoot}, R2: {SecondRoot}";
        Console.WriteLine(message);
    }
}

class Program
{
    static void Main()
    {
        QuadraticEquation equation;

        // pair roots
        equation = new(1, -3, 2);
        Debug.Assert(equation.Discriminant > 0);
        equation.CalculateRoots();
        Debug.Assert(equation.FirstRoot == 2 && equation.SecondRoot == 1);

        // single root
        equation = new(1, -2, 1);
        Debug.Assert(equation.Discriminant == 0);
        equation.CalculateRoots();
        Debug.Assert(equation.FirstRoot == 1 && equation.FirstRoot == equation.SecondRoot);

        // unsolvable root
        try {
            equation = new(1, 2, 3);
            Debug.Assert(equation.Discriminant < 0);
            equation.CalculateRoots(); // we cannot calculate that root
            Debug.Assert(false); // so this is literally unreachable
        } catch {
            Debug.Assert(true); // and here we are catching exception
        }
    }
}
