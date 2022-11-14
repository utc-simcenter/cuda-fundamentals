#include <stdio.h>

// Pretty-print arr of size size
void print_array(int *arr, int size) {
    for(int i=0; i<size; i++)
        printf("%d ", arr[i]);
    printf("\n");
}

// The GPU kernel - each thread adds one to a given element
__global__ void addOne(int *input, int *output) {
    // Calculate global index based on thread position variables
    int index = blockDim.x * blockIdx.x + threadIdx.x;

    output[index] = input[index] + 1;
}

int main(int argc, char *argv[]) {
    int problem_size = 8;
    int input[problem_size] = {0, 1, 2, 3, 4, 5, 6, 7};
    int output[problem_size];

    // GPU Memory Allocation
    int *d_input, *d_output;
    cudaMalloc(&d_input, sizeof(int)*problem_size);
    cudaMalloc(&d_output, sizeof(int)*problem_size);

    // Copy data from input (CPU array) to d_input (GPU array)
    cudaMemcpy(d_input, input, sizeof(int)*problem_size, cudaMemcpyHostToDevice);

    // Launch kernel with 2 blocks of 4 threads
    addOne<<<2, 4>>>(d_input, d_output);
  
    // Copy data from d_output (GPU array) to output (CPU array)
    cudaMemcpy(output, d_output, sizeof(int)*problem_size, cudaMemcpyDeviceToHost);

    // Print out result to check for correct result
    print_array(output, problem_size);
}
