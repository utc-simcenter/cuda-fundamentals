#include <stdio.h>

// Utility to pretty-print arrays
void print_array(int *arr, int size) {
    for(int i=0; i<size; i++)
        printf("%d ", arr[i]);
    printf("\n");
}

// Kernel that doubles each element in an array and stores the result
__global__ void double_arr(int *input, int *output) {
    int index = blockDim.x * blockIdx.x + threadIdx.x;

    output[index] = input[index] * 2;
}

int main(int argc, char *argv[]) {
    int problem_size = 10;
    int input[problem_size] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    int output[problem_size];

    // 1. Allocate GPU Memory
    int *d_output, *d_input;
    cudaMalloc(&d_output, sizeof(int)*problem_size);
    cudaMalloc(&d_input, sizeof(int)*problem_size);

    // 2. Copy input array to d_input
    cudaMemcpy(d_input, input, sizeof(int)*problem_size, cudaMemcpyHostToDevice);

    // 3. Run kernel using 1 block of 10 threads
    double_arr<<<1, 10>>>(d_input, d_output);

    // 4. Copy d_output back to output
    cudaMemcpy(output, d_output, sizeof(int)*problem_size, cudaMemcpyDeviceToHost);

    // 5. Print out the array and check the result
    print_array(output, problem_size);
}
