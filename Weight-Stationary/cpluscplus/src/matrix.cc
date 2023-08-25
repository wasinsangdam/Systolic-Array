#include "../inc/matrix.h"

Matrix::Matrix() {
    matrixPtr = new unsigned int*[ROW];

    for (int i = 0; i < ROW; i++) 
        matrixPtr[i] = new unsigned int[COL];
}

Matrix::~Matrix() {
    for (int i = 0; i < ROW; i++) 
        delete[] matrixPtr[i];

    delete[] matrixPtr;
}

void Matrix::initMatrix() {
    for (int i = 0; i < ROW; i++) {
        for (int j = 0; j < COL; j++) {
            matrixPtr[i][j] = rand() % 16;
        }
    }
}

unsigned int** Matrix::getMatrix() {
    return matrixPtr;
}

void Matrix::setMatrix(unsigned int** matrix) {
    matrixPtr = matrix;
}

void Matrix::multMatrix(Matrix* matrixWeight, Matrix* matrixResult) {

    unsigned int** tempInput  = matrixPtr;
    unsigned int** tempWeight = matrixWeight->getMatrix();
    unsigned int** tempResult = matrixResult->getMatrix(); 

    for  (int i = 0; i < ROW; i++) {
        for (int j = 0; j < COL; j++) {
            
            unsigned int acc = 0;
            
            for (int k = 0; k < COL; k++) {
                acc += tempInput[i][k] * tempWeight[k][j];
            }

            tempResult[i][j] = acc;
        }
    }

    matrixResult->setMatrix(tempResult);
}

void Matrix::printMatrix(std::string name) {

    std::cout << "[" << name << "]" << "\n";

    for (int i = 0; i < ROW; i++) {
        for (int j = 0; j < COL; j++) {
            std::cout << std::setw(3) << matrixPtr[i][j] << " ";
        }
        std::cout << "\n";
    }
    std::cout << "\n";
}

void Matrix::saveMatrixRow(int num) {

    std::string file_name = "../data/input_row" + std::to_string(num) + ".txt";
    
    std::ofstream file(file_name, std::ios_base::app);

    if (!file.is_open()) {
        std::cout << "File Open Error!\n";
        exit(0);
    }

    for (int i = 0; i < COL; i++) {
        file << matrixPtr[i][num-1] << "\n"; // Transposed Input Row
    }

    file.close();
}

void Matrix::saveMatrixCol(int num) {

    std::string file_name = "../data/weight_col" + std::to_string(num) + ".txt";

    std::ofstream file(file_name, std::ios_base::app);

    if (!file.is_open()) {
        std::cout << "File Open Error!\n";
        exit(0);
    }

    for (int i = 0; i < ROW; i++) {
        file << matrixPtr[ROW-i-1][num-1] << "\n";
    }

    file.close();
}
