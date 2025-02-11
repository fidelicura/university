using System.Diagnostics;

namespace sharp;

using FieldsTypesTupled = (string, int, float, char);

readonly public struct Option<T> where T : notnull
{
    public static Option<T> None => default;
    public static Option<T> Some(T value) => new(value);

    readonly bool isSome;
    readonly T? value;

    private Option(T value)
    {
        this.value = value;
        isSome = this.value is { };
    }

    readonly public bool IsSome()
    {
        return isSome;
    }

	readonly public bool IsNone()
	{
		return !isSome;
	}

	/// <summary>
	/// SAFETY: does not check if `this` contains a value.
	/// </summary>
	#pragma warning disable 8603 // see SAFETY doc-comment
	readonly public T UnwrapUnchecked()
	{
		return value;
	}
}

public class MyClass
{
	readonly public string PublicField;
	readonly protected int ProtectedField;
	readonly private float PrivateField;
	readonly internal char InternalField;

	public MyClass()
	{
		PublicField = "Welcome";
		ProtectedField = -12;
		PrivateField = (float)Math.PI;
		InternalField = 'A';
	}

	/// read only props are really cool
	public (string, int, float, char) ReadOnly => (PublicField, ProtectedField, PrivateField, InternalField);

	/// write only props are total bullshit
	public (string, int, float, char) WriteOnly { private get; set; }

	public (string, int, float, char) ReadWrite { get; set; }

	private Option<(string, int, float, char)> WriteOnceReadManyInner = new();
	public Option<(string, int, float, char)> WriteOnceReadMany
	{
		set
		{
			if (WriteOnceReadManyInner.IsNone() && value.IsSome()) WriteOnceReadManyInner = value;
		}
		get
		{
			return WriteOnceReadManyInner;
		}
	}

	public void PrintAllFields()
	{
		Console.WriteLine($"{PublicField} {ProtectedField} {PrivateField} {InternalField}");
	}
}

public class Program
{
	public static void Main()
	{
		MyClass obj = new();

		// https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/access-modifiers
		_ = obj.PublicField; // OK: nothing bad
		// float _privateField = obj.PrivateField; // ERR: from code in the same class or struct only
		// int _protectedField = obj.ProtectedField; // ERR: from code in the same or derived class only
		_ = obj.InternalField; // OK: from current library or binary assembly only

		FieldsTypesTupled FirstValues = ("Bad", 4, (float)Math.E, 'X');

		_ = obj.ReadOnly; // OK: object property is readable
		// obj.ReadOnly = Values; // ERR: object property is not writeable

		// _ = obj.WriteOnly; // ERR: object property is not readable
		obj.WriteOnly = FirstValues; // OK: object property is writeable

		_ = obj.ReadWrite; // OK: object property is readable
		obj.ReadWrite = FirstValues; // OK: object property is writeable

		FieldsTypesTupled SecondValues = ("Cool", 52, (float)1.5, 'F');

		Option<FieldsTypesTupled> is_not_written_yet = obj.WriteOnceReadMany;
		Debug.Assert(is_not_written_yet.IsNone());

		obj.WriteOnceReadMany = Option<FieldsTypesTupled>.Some(SecondValues);
		Option<FieldsTypesTupled> is_already_written = obj.WriteOnceReadMany;
		Debug.Assert(is_already_written.IsSome());

		obj.WriteOnceReadMany = Option<FieldsTypesTupled>.None;
		Option<FieldsTypesTupled> is_not_overridden = obj.WriteOnceReadMany;
		Debug.Assert(is_not_overridden.IsSome());
	}
}
