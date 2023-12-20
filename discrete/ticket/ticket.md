# <p align="center">Безуглый Кирилл, СП-23, Билет №8</p>

### №1

Пример инъективной функции - любая **хэш-функция**. Она получает любое значение (первое условие), отображается на не каждое результативное значение (второе условие).
Или, $\forall n \in \mathbb N: f(n) = n^{2}$.

### №2

Дано: $A - X = B - A = \not A = \varnothing$ при $\not X \neq \varnothing$.
Решение:
$A - X = \{1, 2\}$
$B - A = \{3, 6\}$
$\not A = \varnothing = \{\}$
$\not X \neq \varnothing = \{\not1, \not2, \not3, 8\}$
Вычеркиваем $1, 2, 3$, ответ - $8$.


### №3

$(X - Y) \cap (X \bigtriangleup Z) = X \cap \not Y \cap \not Z$;
$(X \cap \not Y) \cap (X \bigtriangleup Z) = X \cap \not Y \cap \not Z$;
$X \cap \not Y \cap ((X - Z) \cup (Z - X)) = X \cap \not Y \cap \not Z$;
$X \cap \not Y \cap ((X - Z) \cup (Z - X)) = X \cap \not Y \cap \not Z$;
$X \cap \not Y \cap ((X \cap \not Z) \cup (Z \cap \not X)) = X \cap \not Y \cap \not Z$;
$X \cap \not Y \cap (X \cap \not Z \cup Z \cap \not X) = X \cap \not Y \cap \not Z$;

### №4

Дано: $2f_{n+2} + 5f_{n+1} + 3f_{n} = 0$ при $f_{1} = 1$ и $f_{2} = 2$.
Решение:
Представим $f_{n}$ (как минимальное $n$) как $\lambda$.
Подставим $\lambda$ и получим $2\lambda^{2} + 5\lambda + 3$.
Решим получившееся квадратное уравнение, заменив $\lambda$ на $x$ (для упрощения):
$2x^{2} + 5x + 3 = 0$;
$a = 2, b = 5, c = 3$; 
$\mathbb D = b^{2} - 4 \times a \times c$;
$\mathbb D = 25 - 4 \times 2 \times 3 = 25 - 24 = 1$;
$\mathbb D = 1$. Дискриминант больше нуля, значит имеется _два_ корня:
$x_{1} = \frac{-b + \sqrt{\mathbb D}}{2 \times a} = \frac{-5 + \sqrt{1}}{4} = \frac{-4}{4} = -1$;
$x_{2} = \frac{-b - \sqrt{\mathbb D}}{2 \times a} = \frac{-5 - \sqrt{1}}{4} = \frac{-6}{4} - -1 \frac{2}{4} = -1 \frac{1}{2} = -1.5$;
$x_{1} = -1,\ x_{2} = -1.5$;
Составим формулу общего члена на основе корней дискриминанта:
$C_{1} \times (-1)^{n} + C_{2} \times (-1.5)^{n}$;
При $f_{1}$: $C_{1} \times (-1)^{1} + C_{2} \times (-1.5)^{1} = 1$;
При $f_{2}$: $C_{1} \times (-1)^2 + C_{2} \times (-1.5)^{2} = 2$, сократим до $C_{1} + C_{2} \times 2.25 = 2$;
Составим _общую_ матрицу и решим:
$$
\begin{bmatrix}
-1 & -1.5 & \| 1 \\
1 & 2.25 & \| 2
\end{bmatrix}
$$
Найдем $\bigtriangleup_{1}$, $\bigtriangleup_{2}$ и _общее решение_ в виде $\bigtriangleup$:
$\bigtriangleup_{1}$ = $$
\begin{bmatrix}
1 & -1.5 \\
2 & 2.25
\end{bmatrix}
$$ = $1 \times 2.25 - 2 \times -1.5 = 2.25 + 3 = 5.25$

$\bigtriangleup_{2}$ = $$
\begin{bmatrix}
-1 & 1 \\
1 & 2
\end{bmatrix}
$$ = $-1 \times 2 - 1 \times 1 = -2 - 1 = -3$

$\bigtriangleup$ = $$
\begin{bmatrix}
-1 & -1.5 \\
1 & 2.25
\end{bmatrix}
$$ = $-1 \times 2.25 - 1 \times -1.5 = 2.25 + 1.5 = 3.75$
Найдем $c_{1}$ и $c_{2}$:
$c_{1} = \frac{\bigtriangleup_{1}}{\bigtriangleup} = \frac{5.25}{3.75}$;
$c_{2} = \frac{\bigtriangleup_{2}}{\bigtriangleup} = \frac{-3}{3.75}$;
Отсюда, _формула общего члена_ будет иметь вид $f_{n} = c_{1} \times f_{n-1} + c_{2} \times f_{n-2}$.

### №5

1\) $9 \times 9 \times 9 \times 9 = 6561$ вариантов;
2\) $1 + 9 \times 9 + 1 = 83$ варианта;
3\) $9 \times 8 \times 7 \times 6 = 3024$ варианта;

### №6

Дано: $a = b$ - прямая в пространстве, $f$ - условие общей точки, задано $f = (a, b)$.
Решение:
Рефлексивность: $f = (a, a) \eq f(a, a)$ - "если у $a$ общая точка, то и у $a$ с $a$ есть общая точка, и наоборот (в том числе с отрицанием)": функция **рефлексивна**;
Симметричность: $f = (a, b) \implies f(b, a)$ - "если есть общая точка у $a$ и у $b$, то и у $b$ с $a$ будет общая точка, и наоборот (в том числе с отрицанием)": функция **симметрична**.
Транзитивность: $f = (a, b), f = (b, c) \implies f(a, c)$ - "если есть общая точка у $a$ и у $b$, а также у $b$ с $c$, то и у $a$ с $c$ есть общие точки, и наоборот (в том числе с отрицанием)": функция **транзитивна**;
Полнота: $\forall a, b: \exists a \lor \exists b: f \neq (a, b)$ - "если у $a$ и $b$ нет общих точек, то функция не выполняется": функция **неполная**;
