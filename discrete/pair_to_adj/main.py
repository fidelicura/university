from numpy import zeros

first = 1
second = -2

def algo(edges):
    n = len(edges)
    matrix = zeros((n, n), dtype=int)
    for edge in edges:
        matrix[edge[0]][edge[1]] = 1
        matrix[edge[1]][edge[0]] = 1
    return matrix

def ask():
    user = input("Введите пару в формате `1,1`: ").split(",")
    return (int(user[0]), int(user[1]))

if __name__ == "__main__":
    user = int(input("Введите количество пар по следующему условию:\nОт двух связных пар, где 0 - А, 1 - B и так далее.\nНапример: 4, (0, 1), (1, 2), (2, 3), (3, 0)\nВведите количество пар (от 2): "))    
    if user < 2:
        print("Количество пар меньше двух!")
        exit(1)

    pairs = [ask() for _ in range(0, user)]
    print(f"\nЗаданные пары: {pairs}")
    print(f"\nРезультат:\n{algo(pairs)}")
