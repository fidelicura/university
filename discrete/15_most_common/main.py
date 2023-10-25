from collections import Counter

def find_most_appeared_symbols(string):
    counter = Counter(string)
    most_common = counter.most_common(15)
    return most_common

string = "Только боль как пожар, за ударом ждешь удар. Или в ад, или в рай, все пути открыты, только выбирай."
most_appeared_symbols = find_most_appeared_symbols(string)
counter = 0
for i, j in most_appeared_symbols:
    counter += 1
    print(f"{i}: {j}")

print(f"\n{counter}")
print(len(string))
