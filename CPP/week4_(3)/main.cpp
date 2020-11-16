#include <iostream>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

const int munSize = 10;    //Количество военного имущества.
int cntr = 0;   //Количество вынесеного имммущества.
int cost = 0;    //Суммманая стоимость вынесенного имущества.
int munition[munSize];  //Военное имущество.
int delCost = 4;    //Делитель Стоимости одного оборудования на рынке.
int front = 0; //Индекс для чтения из буффера.
int rear = 0;   //Индекс для записи в буффер.
sem_t empty; //семафор - буффер пуст
sem_t full; //семафор - буффер полон
pthread_mutex_t mutexW; //mutex для записи
pthread_mutex_t mutexR; //mutex для чтения
pthread_mutex_t mutexC; //mutex для счетчика

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
    //Инициализируем мутексы.
    pthread_mutex_init(&mutexW, nullptr);
    pthread_mutex_init(&mutexR, nullptr);
    pthread_mutex_init(&mutexC, nullptr);
    //Семафоры.
    sem_init(&empty, 0, munSize);
    sem_init(&full, 0, 0);

    //Пускаем производителя - выносит оборудование из склада.
    pthread_t threadProd;
    std::string pName = "Иванов";
    pthread_create(&threadProd, nullptr, Producer, (void *) (&pName));

    //Пускаем потребителя - загружает в машину.
    pthread_t threadCons;
    std::string cName = "Петров";
    pthread_create(&threadCons, nullptr, Consumer, (void *) (&cName));

    //Главный поток - подсчет количества вынесенного оборудования.
    std::string cntrName = "Нечепорчук";
    Counter((void *) &(cntrName));

    return 0;
}

void *Producer(void *mun) {
    const char *pName = (*((std::string *) mun)).c_str();
    while (true) {
        int data = rand() % 10000; //Генерируем номер оборудования
        pthread_mutex_lock(&mutexW);    //Закрываем мутекс.
        sem_wait(&empty);   //Количество свободных ячеек увеличилось на 1
        munition[rear] = data;
        rear = (rear + 1) % munSize;
        sem_post(&full);    //количество занятых ячеек уменьшить на 1
        pthread_mutex_unlock(&mutexW);  //Открываем мутекс.
        printf("Прапорщик %s выносит имущество № [%d] со склада.\n", pName, data);

        sleep(2);
    }
}

void *Consumer(void *mun) {
    const char *cName = (*((std::string *) mun)).c_str();
    int res;
    while (true) {
        pthread_mutex_lock(&mutexR);    //Закрываем мутекс.
        sem_wait(&full);    //количество занятых ячеек уменьшить на 1
        res = munition[front];
        front = (front + 1) % munSize;
        sem_post(&empty);   //Количество свободных ячеек увеличилось на 1
        pthread_mutex_unlock(&mutexR);  //Открываем мутекс.
        printf("Прапорщик %s грузит оборудование № [%d] в грузовик.\n", cName, res);
        ++cntr;
        sleep(4);
    }
}

void *Counter(void *mun) {
    const char *cntrName = (*((std::string *) mun)).c_str();

    while (true) {
        pthread_mutex_lock(&mutexC);
        sem_wait(&full);

        if (cntr > munSize & (cntr - 1) % munSize == 0)
            printf("Оборудования там больше, чем казалось... Берем все!\n");
        sem_post(&empty);
        pthread_mutex_unlock(&mutexC);
        cost += munition[cntr % munSize - 1] / delCost;  //Суммируем стоимость вынесенного оборудования.

        printf("Прапорщик %s подчитал, что было вынесено оборудования (%dшт.) на сумму %d у.е.\n", cntrName, cntr,
               cost);
        sleep(4);
    }
}