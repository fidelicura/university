size = 8
INF = 999


def floyd(graph, counter):
    distance = list(map(lambda i: list(map(lambda j: j, i)), graph))

    for k in range(size):
        for i in range(size):
            for j in range(size):
                distance[i][j] = min(distance[i][j], distance[i][k] + distance[k][j])
        print_solution(distance, counter)
        counter += 1


def print_solution(distance, counter):
    for i in range(size):
        for j in range(size):
            if(distance[i][j] == INF):
                print("INF", end=" ")
            else:
                print(distance[i][j], end="  ")
        print(" ")
    print(f"-----------------------#{counter}------------------")


if __name__ == "__main__":
    counter = 1
    graph = [
        [0, INF, 8, 7, INF, INF, 5, 4],
        [INF, 0, 6, INF, INF, 8, INF, INF],
        [8, 6, 0, 7, 5, 10, INF, INF],
        [7, INF, 7, 0, 9, INF, 8, INF],
        [INF, INF, 5, 9, 0, 8, INF, 10],
        [INF, 8, 10, INF, 8, 0, INF, 3],
        [5, INF, INF, 8, INF, INF, 0, 5],
        [4, INF, INF, INF, 10, 3, 5, 0]
    ]
    floyd(graph, counter)
