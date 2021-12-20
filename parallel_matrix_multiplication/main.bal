import ballerina/io;

public function main() {
    int[][] mat1 = [
        [1, 10, 3],
        [4, 5, 0],
        [8, 3, 7]
    ];

    int[][] mat2 = [
        [1, 10, 3],
        [4, 5, 0],
        [8, 3, 7]
    ];

    int[][] result = multiply(mat1, mat2);
    foreach var line in result {
        foreach var item in line {
            io:print(`${item}${"\t"}`);
        }
        io:println();
    }
}

# Multiplies provided 2 matrices and return the resulting matrix.
#
# + mat1 - Matrix 1
# + mat2 - Matrix 2
# + return - Return Value Description  
function multiply(int[][] mat1, int[][] mat2) returns int[][] {
    int[][] result = [];
    int len = mat1[0].length();

    future<error?>[] futures = [];
    foreach int i in 0 ..< len {
        foreach int j in 0 ..< len {
            future<error?> f = @strand{thread: "any"} start calculate(mat1, mat2, result, i, j);
            futures.push(f);
        }
    }

    foreach future item in futures {
        error? err = wait item;
        if err is error {
            io:println("Failed to calculate value", err);
        }
    }

    return result;
}


# Given two matrices, mat1 and mat2, this will calculate the result of the matrix multiplication at index i,j and assign the
# value to the resultant matrix's position i,j.
#
# + mat1 - Matrix 1
# + mat2 - Matrix 2  
# + result - Resulting matrix
# + i - Position i  
# + j - Position j  
function calculate(int[][] mat1, int[][] mat2, int[][] result, int i, int j) {
    int sum = 0;

    int len = mat1[0].length();
    foreach int x in 0 ..< len {
        sum += mat1[i][x] * mat2[x][j];
    }

    result[i][j] = sum;
}
