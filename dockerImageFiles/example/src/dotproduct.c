#include <stdio.h>

const unsigned int BSIZE = 32;

#pragma omp target device(fpga)
#pragma omp task in([BSIZE]v1, [BSIZE]v2) inout([1]result)
void dotProduct(float *v1, float *v2, float *result) {
  int resultLocal = result[0];
  for (unsigned int i = 0; i < BSIZE; ++i) {
    resultLocal += v1[i]*v2[i];
  }
  result[0] = resultLocal;
}

int main() {
  unsigned int vecSize = 256;
  float v1[vecSize];
  float v2[vecSize];

  //Initialize the vectors
  for (unsigned int i = 0; i < vecSize; ++i) {
    v1[i] = i + 1;
    v2[i] = 2;
  }

  float result = 0;
  for (unsigned int i = 0; i < vecSize; i += BSIZE) {
    dotProduct(v1+i, v2+i, &result);
  }
  #pragma omp taskwait

  //Check the result value
  float expectedResult = vecSize*(vecSize + 1);
  if (result != expectedResult) {
    printf("ERROR: Unexpected result %f (expected: %f)\n", result, expectedResult);
  } else {
    printf("Result is OK!\n");
  }
}
