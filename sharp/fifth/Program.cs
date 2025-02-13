using System.Collections;
using System.Text.Json;

namespace fifth;

class Element(string name, int index)
{
    public string Name { get; set; } = name;
    public int Index { get; set; } = index;

    public void PrintName()
    {
        Console.WriteLine($"Name: {Name}, Index: {Index}");
    }
}

class Elements : IEnumerable<Element>
{
    private List<Element> items = [];

    public void Add(Element item) => items.Add(item);
    public void Insert(int index, Element item) => items.Insert(index, item);
    public void RemoveAt(int index) => items.RemoveAt(index);
    public void Clear() => items.Clear();
    public int Count => items.Count;
    public Element this[int index] => items[index];
    public void PrintAll() => items.ForEach(e => e.PrintName());
    public Element[] ToArray() => [..items];

	readonly public JsonSerializerOptions options = new() { WriteIndented = true };

    public async Task SerializeAsync(string filePath)
    {
        string jsonString = JsonSerializer.Serialize(items, options);
        await File.WriteAllTextAsync(filePath, jsonString);
    }

    public async Task DeserializeAsync(string filePath)
    {
        if (File.Exists(filePath))
        {
            string jsonString = await File.ReadAllTextAsync(filePath);
            items = JsonSerializer.Deserialize<List<Element>>(jsonString) ?? [];
        }
    }

    public IEnumerator<Element> GetEnumerator() => items.GetEnumerator();
    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}

class Program
{
    async static Task Main()
    {
        // fill collection
        Elements collection = [];
        for (int i = 1; i <= 12; i++)
            collection.Add(new Element($"Element-{i}", i));

        // print collection information
        Console.WriteLine("Initial collection:");
        collection.PrintAll();

        // insert at the middle of collection
        collection.Insert(5, new Element("Inserted Element", 99));
        Console.WriteLine("\nCollection after insertion:");
        collection.PrintAll();

        // serialize the collection
        string filePath = "elements.dat";
        await collection.SerializeAsync(filePath);

        // remove from the middle of collection
        collection.RemoveAt(3);
        Console.WriteLine("\nCollection after removal:");
        collection.PrintAll();

        // copy collection into an array
        Element[] arrayCopy = [..collection];
        Console.WriteLine("\nCopied array:");
        foreach (var element in arrayCopy)
        element.PrintName();

        // clear the collection
        collection.Clear();
        Console.WriteLine("\nCollection after clearing:");
        Console.WriteLine("Count: " + collection.Count);
        collection.PrintAll();

        // deserialize collection
        await collection.DeserializeAsync(filePath);
        Console.WriteLine("\nDeserialized collection:");
        collection.PrintAll();
    }
}
