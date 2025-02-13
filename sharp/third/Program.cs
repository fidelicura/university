using System.Runtime.CompilerServices;
using System.Diagnostics;

namespace third;

class First
{
	public virtual int Calc(int value)
	{
		return value * value;
	}

	public static void Calc(ref int value)
	{
		value *= value;
	}

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
	private static void BubbleSort(ref int[] array)
	{
	    for (int i = 0; i < array.Length - 1; i++) 
	        for (int j = 0; j < array.Length - i - 1; j++) 
	            if (array[j] > array[j + 1]) 
					(array[j], array[j + 1]) = (array[j + 1], array[j]);
	}

	public static void Calc(int element, ref int[] array)
	{
	    int[] temp = new int[array.Length + 1];
	    temp[0] = element;
	    Array.Copy(array, 0, temp, 1, array.Length);

		BubbleSort(ref temp);
		array = temp;
	}
}

class Second : First
{
	public override int Calc(int value)
	{
		int result = base.Calc(value);
		return result * result * result;
	}
}

class Third : Second;

class Program
{
	private static string FormatArray(int[] array)
	{
		return '[' + string.Join(", ", array.Select(n => n.ToString())) + ']';
		
	}

	private static bool CompareArrays(int[] lhs, int[] rhs)
	{
		string lhsRepr = FormatArray(lhs), rhsRepr = FormatArray(rhs);
		Console.WriteLine($"[COMPARE]\n{lhsRepr}\n\t[==]\n{rhsRepr}\n[COMPARE]");

		if (lhs.Length != rhs.Length)
			return false;
		int length = lhs.Length;

		for (int idx = 0; idx < length; idx++)
			if (lhs[idx] != rhs[idx])
				return false;
		return true;
	}

	public static void Main()
	{
        First first = new();
        Debug.Assert(first.Calc(3) == 9, "should return 9");

        int value = 4;
        First.Calc(ref value);
        Debug.Assert(value == 16, "should set `value` to 16");

        int[] initial = [-2, 0, 4, -7];
        First.Calc(1, ref initial);
		int[] expected = [-7, -2, 0, 1, 4];
        Debug.Assert(CompareArrays(initial, expected), "should insert element 1 and sort an array");

        Second second = new();
        Debug.Assert(second.Calc(3) == 729, "should return 729"); // (3*3)^3 = 9^3 = 729

        Third third = new();
        Debug.Assert(third.Calc(3) == 729, "should return 729, since it inherits from class `Second`");
	}
}
