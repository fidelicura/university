using System.Runtime.CompilerServices;
using System.Diagnostics;
using System.Text;

namespace second;

// we don't care to override `Object.GetHashCode` method for now 
#pragma warning disable 0659
public class Human : IEquatable<Human>
{
	readonly private string? Name;
	readonly private uint? Age;
	readonly private char? Blood;
	readonly private double? Weight;

	readonly public static StringBuilder DestructorMessages = new();

	public (string, uint, char, double, StringBuilder) ReadWrite { get; set; }

	// default nullified constructor
	public Human()
	{
		Name = null;
		Age = null;
		Blood = null;
		Weight = null;
	}

	// overloaded with first two fields
	public Human(string name, uint age)
	{
		Name = name;
		Age = age;
		Blood = null;
		Weight = null;
	}

	// overloaded with other two fields
	public Human(char blood, double weight)
	{
		Name = null;
		Age = null;
		Blood = blood;
		Weight = weight;
	}

	// overloaded and inherited constructor
	public Human(string name) : this()
	{
		Name = name;
	}

	// used for tests to full initialization
	public Human(string? name, uint? age, char? blood, double? weight)
	{
		Name = name;
		Age = age;
		Blood = blood;
		Weight = weight;
	}

	~Human()
	{
		string message = $"[DESTRUCTOR] {this} [DESTRUCTOR]";
		DestructorMessages.AppendLine(message);
	}

	/// <summary>
	/// SAFETY: does not check if passed `obj` is not a `null`.
	/// </summary>
	public override bool Equals(object? obj)
	{
		return Equals(obj as Human);
	}

	/// <summary>
	/// SAFETY: does not check if passed `other` is not a `null`.
	/// </summary>
	public bool Equals(Human? other)
	{
		Console.WriteLine($"[COMPARISON] {{\n{this}\n\t[==]\n{other}\n}} [COMPARISON]\n");

		if (other == null)
			return false;

		return Name == other.Name
			&& Age == other.Age
			&& Blood == other.Blood
			&& Weight == other.Weight;
	}

	public override string ToString()
	{
	    return $"{Name ?? "_"} of age {Age ?? '_'} with blood type {Blood ?? '_'} and weight of {Weight ?? '_'}";
	}
}

public class Program
{
	[MethodImpl(MethodImplOptions.NoOptimization)]
	private static void CreateAndDestroy()
	{
		_ = new Human();
	}

	public static void Main()
	{
		// default constructor does not initialize object fields
		Human obj = new();
		Debug.Assert(obj.ReadWrite.Item1 == null);

		// overloaded constructor with first two fields initialized
		string name = "Kelthuzad";
		uint age = 100000;
		obj = new(name, age);
		Human expected = new(name, age, null, null);
		Debug.Assert(obj.Equals(expected));

		// overloaded constructor with other two fields initialized
		char blood = 'A';
		double weight = 10.28;
		obj = new(blood, weight);
		expected = new(null, null, blood, weight);
		Debug.Assert(obj.Equals(expected));

		// overloaded with inhertied null constructor
		name = "Sargeras";
		obj = new(name);
		expected = new(name, null, null, null);
		Debug.Assert(obj.Equals(expected));

		// check message at destructor call
		CreateAndDestroy();
		GC.Collect();
		GC.WaitForPendingFinalizers();
		Debug.Assert(Human.DestructorMessages.ToString() != null);
		Console.WriteLine(Human.DestructorMessages.ToString());
	}
}
