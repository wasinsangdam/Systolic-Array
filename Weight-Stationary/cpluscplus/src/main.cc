#include "../inc/matrix.h"

int main (void) {
    Matrix* matrixInput  = new Matrix;
    Matrix* matrixWeight = new Matrix;
    Matrix* matrixResult = new Matrix;

    

    for (int i = 0; i < 16; i++) {

        std::cout << "[Test "<< std::setw(2) << i << "]\n" << "----------------" << "\n";
        matrixInput->initMatrix();
        matrixInput->printMatrix("Input Matrix");
        
        if (i % 4 == 0) {
            matrixWeight->initMatrix();
        }
        matrixWeight->printMatrix("Weight Matrix");

        matrixInput->multMatrix(matrixWeight, matrixResult);

        matrixResult->printMatrix("Result Matrix");

        matrixInput->saveMatrixRow(1);
        matrixInput->saveMatrixRow(2);
        matrixInput->saveMatrixRow(3);
        matrixInput->saveMatrixRow(4);
        
        if (i % 4 == 0) {
            matrixWeight->saveMatrixCol(1);
            matrixWeight->saveMatrixCol(2);
            matrixWeight->saveMatrixCol(3);
            matrixWeight->saveMatrixCol(4);
        }
        std::cout << "----------------\n";
    }

    return 0;
}
