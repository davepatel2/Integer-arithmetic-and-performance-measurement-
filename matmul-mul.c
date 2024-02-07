void matmul(int* C, const int* A, const int* B, unsigned int hA, 
    unsigned int wA, unsigned int wB)
{
  unsigned int i, j, k;
  for (i = 0; i < hA; ++i)
    for (j = 0; j < wB; ++j) {
      int sum = 0;
      for (k = 0; k < wA; ++k) {
        sum += A[i * wA + k] * B[k * wB + j];
      }
      C[i * wB + j] = sum;
    }
}
