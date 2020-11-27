#include <iostream>
#include <unistd.h>
#include <omp.h>

const int munSize = 10;    //Количество военного имущества.
int cntr = 0;   //Количество вынесеного имущества.
int cost = 0;    //Суммманая стоимость вынесенного имущества.
int munition[munSize];  //Военное имущество.
int delCost = 4;    //Делитель Стоимости одного оборудования на рынке.
int front = 0; //Индекс для чтения из буффера.
int rear = 0;   //Индекс для записи в буффер.
bool iDone = false; //Иванов выполнил работу.
bool pDone = false; //Петров выполнил работу.
bool nDone = true;  //Нечепорчук выполнил работу.


/**
 * Метод передается в поток в качестве производителя.
 * @param mun Идентификатор производителя.
 */
void *Producer(void *mun);

/**
 * Метод передается в поток в качестве потребителя.
 * @param mun Идентификатор потребителя.
 */
void *Consumer(void *mun);

/**
 * Метод передается в поток в качестве счетчика срабатываний производителя-потребителя.
 * Работает аналогично потребителю.
 * @param mun Идентификатор счетчика.
 */
void *Counter(void *mun);

int main() {
#pragma omp parallel num_threads(3)
    {
        int trN = omp_get_thread_num();
        if (trN == 1) {
            std::string pName = "Иванов";
            Producer((void *) &(pName));
        } else if (trN == 2) {
            std::string cName = "Петров";
            Consumer((void *) &(cName));
        } else {
            std::string cntrName = "Нечепорчук";
            Counter((void *) &(cntrName));
        }
    }
    return 0;
}

void *Producer(void *mun) {
    const char *pName = (*((std::string *) mun)).c_str();
    while (true) {
        while (!nDone);
        nDone = false;
        int data = rand() % 10000; //Генерируем номер оборудования
        munition[rear] = data;
        rear = (rear + 1) % munSize;
        printf("Прапорщик %s выносит имущество № [%d] со склада.\n", pName, data);
        sleep(1);
        iDone = true;
    }
}

void *Consumer(void *mun) {
    const char *cName = (*((std::string *) mun)).c_str();
    int res;

    while (true) {
        while (!iDone); //Пока Иванов не сделал вынес.
        iDone = false;
        res = munition[front];
        front = (front + 1) % munSize;
        printf("Прапорщик %s грузит оборудование № [%d] в грузовик.\n", cName, res);
        ++cntr;

        sleep(1);
        pDone = true;
    }
}

void *Counter(void *mun) {
    const char *cntrName = (*((std::string *) mun)).c_str();
    while (true) {
        while (!pDone);
        pDone = false;
        if (cntr > munSize & (cntr - 1) % munSize == 0)
            printf("Оборудования там больше, чем казалось... Берем все!\n");
        cost += munition[cntr % munSize - 1] / delCost;  //Суммируем стоимость вынесенного оборудования.

        printf("Прапорщик %s подчитал, что было вынесено оборудования (%dшт.) на сумму %d у.е.\n", cntrName, cntr,
               cost);

        sleep(1);
        nDone = true;
    }
}