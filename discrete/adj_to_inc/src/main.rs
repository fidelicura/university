type Matrix = Vec<Vec<i32>>;

fn convert(matrix: Matrix) -> Vec<Vec<i32>> {
    let len = matrix.len();

    let mut counter = 0;
    let mut result: Matrix = Vec::new();

    for col in 0..len {
        for row in 0..=col {
            if matrix[col][row] == 1 {
                result.push(vec![0; len]);
                result[counter][row] = 1;
                result[counter][col] = 1;
                counter += 1;
            }
        }
    }

    result
}

fn main() {
    let adj: Matrix = vec![
        vec![0, 1, 0, 0, 0, 0, 0],
        vec![1, 0, 1, 1, 1, 1, 0],
        vec![0, 1, 0, 0, 0, 0, 1],
        vec![0, 1, 0, 0, 0, 0, 0],
        vec![0, 1, 0, 0, 0, 1, 0],
        vec![0, 1, 0, 0, 1, 0, 1],
        vec![0, 0, 1, 0, 0, 1, 0],
    ];

    println!("# ADJACENCY #");
    for row in &adj {
        println!("{:?}", row);
    }
    println!("# ADJACENCY #\n");

    let inc: Matrix = convert(adj);
    println!("# INCIDENCE #");
    for row in &inc {
        println!("{:?}", row);
    }
    println!("# INCIDENCE #");
}
