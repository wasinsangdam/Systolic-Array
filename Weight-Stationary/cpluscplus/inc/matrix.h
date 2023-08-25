#include <iostream>
#include <cstdlib>
#include <ctime>
#include <iomanip>
#include <fstream>
#include <string>

#define ROW 4
#define COL 4

// #define RAND_MAX

class Matrix {
private :
    unsigned int** matrixPtr;

public :
    Matrix();
    ~Matrix();

    unsigned int** getMatrix();
    void setMatrix(unsigned int** matrix);
    void initMatrix();
    void multMatrix(Matrix* matrixWeight, Matrix* matrixResult);
    void printMatrix(std::string name);

    void saveMatrixRow(int num);
    void saveMatrixCol(int num);
};