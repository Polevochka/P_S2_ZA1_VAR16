unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  // создадим тип для матрицы
  // нужен для передачи матрыци в функции обработки
  // кстати т.к. он в области interface и этот модуль мы подключаем в unit1
  // то этот тип можо будет использовать в unit1
  TMatrix = array[1..20, 1..20] of integer;

// прототипы функций которые ДОЛЖНЫ быть ВЫДНЫ в ДРУГИХ модулях(unit1)
procedure FillMatrix(var M: TMatrix; rows: integer; cols: integer);
procedure MoveUp(var M:Tmatrix; rows: integer; cols: integer);
procedure MoveDown(var M:Tmatrix; rows: integer; cols: integer);
// Интересно будет отметить, что функцию PosIndexMaxInCol
// здесь не надо указывать, тк она нигде кроме как внутри функций
// MoveUp и MoveDown не используется

implementation

{Процедура заполнения матрицы рандомными числами}
// здесь ВАЖНАЯ ПОПРАВОЧКА
//т.к. этот модуль компилируется отдельно от основной программы
// то randomize в нём работать не будет
// randomize надо вызывать в основной программе
//'var M' - т.к. меняем элементы матрицы
//   rows - число строк матрицы
//   cols - число столбцов матрицы
procedure FillMatrix(var M: TMatrix; rows: integer; cols: integer);
var i, j: integer;
begin
   for i:=1 to rows do
       for j:=1 to cols do
           M[i,j] := random(100); // рандомное число на отрезке [0;99]
end;

{Функция поиска максимального элемента в столбце}
// Возвращает номер строки, в которой находится максимальный элемент из столбца 'c'
//   M - сама матрица в которой ведётся поиск (заметьте без var, тк ничего не меняем здесь)
//   rows - число строк в матрице
//   с - номер столбца в котором ищем максимальный элемент
// Здесь также важно отметить, что ЧИСЛО СТОЛБЦОВ передавать не нужно,
// т.к. поиск ведётся ТОЛЬКО в ОДНОМ столбце с номером c
function PosIndexMaxInCol(M:TMatrix; rows: integer; c: integer): integer;
var i_max: integer; // индекс максимального элемента
    i: integer; // для перебора строк
begin
  // Сначала предполагаем, что максимальный элемент находиться в 1-ой строчке
  // Дальше если найдём элемент побольше, то просто поменяем значение
  i_max := 1;

  // Обходим другие строки и ищем элементы побольше,
  // ПРИЧОМ начиная со 2-ой, т.к. первую строку УЖЕ 'обработали'
  for i:=2 to rows do
    if M[i_max, c] < M[i, c] then i_max := i;

  // найденное значение присваиваем имени функции - это то
  // что оно вернят после своей работы
  PosIndexMaxInCol := i_max;

end;

{Процедура перемещает максимальные элементы в столбцах наверх}
procedure MoveUp(var M:TMatrix; rows: integer; cols: integer);
var i_max: integer; // индекс максимального элемента для j - го столбца
    // вспомогательная переменная для перестановки элементов в матрице
    temp: integer;
    i, j: integer;
begin
  // Сначала обходим все столбцы матрицы
  for j:=1 to cols do
  begin
    // находим индекс максимального элемента в j-ом столбце
    i_max := PosIndexMaxInCol(M, rows, j);

    // передвигаем элемент с этим индексом наверх
    // то есть на ПЕРВУЮ строку матрицы

    // сначала сохраним значение в буферную - вспомогательную переменную
    temp := M[i_max, j];

    // Потом смещаем все элементы выше его вниз на одну позицию(затирая его)
    // до двух, т.к. если i=1 то получится M[i-1, j] = M[0, j] - НЕТ такого элемента
    for i := i_max downto 2 do
        M[i, j]:= M[i-1, j];

    {
        То есть
        было :    1            стало:    1
                  2                      1
                  3                      2
                  max                    3
                  4                      4
                  5                      5
    }

    // нетрудно заметить, что теперь первый  и второй элементы столбца дублируются
    // теперь как раз мы можем записать на первое место наш максимальный элемент,
    // значение которого было сохранено в temp
    M[1,j] := temp;

    // задача для одного столбца выполнена, переходим к другим
  end;
end;

{Процедура перемещает максимальные элементы в столбцах вниз}
procedure MoveDown(var M:TMatrix; rows: integer; cols: integer);
var i_max: integer; // индекс максимального элемента для j - го столбца
    // вспомогательная переменная для перестановки элементов в матрице
    temp: integer;
    i, j: integer;
begin
  // Сначала обходим все столбцы матрицы
  for j:=1 to cols do
  begin
    // находим индекс максимального элемента в j-ом столбце
    i_max := PosIndexMaxInCol(M, rows, j);

    // передвигаем элемент с этим индексом вниз
    // то есть на ПОСЛЕДНЮЮ строку матрицы с индексом rows

    // сначала сохраним значение в буферную - вспомогательную переменную
    temp := M[i_max, j];

    // Потом смещаем все элементы ниже максимума вверх на одну позицию(затирая его)
    // до rows-1, т.к. если i=rows то получится M[i+1, j] = M[rows+1, j] - НЕТ такого элемента
    for i := i_max to rows-1 do
        M[i, j]:= M[i+1, j];

    {
        То есть
        было :    1            стало:    1
                  2                      2
                  max                    3
                  3                      4
                  4                      5
                  5                      5
    }

    // нетрудно заметить, что теперь два последних элемента столбца дублируются
    // теперь как раз мы можем записать на последнее место наш максимальный элемент,
    // значение которого было сохранено в temp
    M[rows,j] := temp;

    // задача для одного столбца выполнена, переходим к другим
  end;
end;

end.
