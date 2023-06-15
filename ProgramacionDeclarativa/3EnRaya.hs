



{----------------------------------------------------------------------------------------------------------------------------------}
{-         __                                            __                                                                       -}
{-         ||============================================||                                                                       -}
{-         ||   · NOMBRE DE LA PRÁCTICA:                 ||              __                                            __         -}
{-         ||       Practica3EnRayaOscar                 ||              ||============================================||         -}
{-         ||   · ASIGNATURA:                            ||              ||   · AUTOR:                                 ||         -}
{-         ||       Programación Declarativa (PRDE)      ||              ||       Óscar Mesa Martín                    ||         -}
{-         ||   · FECHA DE ENTREGA:                      ||              ||============================================||         -}
{-         ||       20 / 12 / 2021                       ||              ""                                            ""         -}
{-         ||============================================||                                                                       -}
{-         ""                                            ""                                                                       -}
{----------------------------------------------------------------------------------------------------------------------------------}


{----------------------------------------------------------------------------------------------------------------------------------}
{-                                                __                           __                                                 -}
{-                                                ||===========================||                                                 -}
{-                                                ||   DESCRIPCIÓN DEL JUEGO   ||                                                 -}
{-                                                ||===========================||                                                 -}
{-                                                ""                           ""                                                 -}
{-                __                                                                                            __                -}
{-                ||============================================================================================||                -}
{-                ||    JUGADORES:                                                                              ||                -}
{-                ||        Se trata de un juego para 2 jugadores, en este caso, se jugará contra la CPU.       ||                -}
{-                ||    TABLERO:                                                                                ||                -}
{-                ||        Consiste en 9 casillas organizadas en un cuadrado de 3x3.                           ||                -}
{-                ||    REGLAS:                                                                                 ||                -}
{-                ||        · TURNOS:                                                                           ||                -}
{-                ||            El turno se alterna entre los dos jugadores.                                    ||                -}
{-                ||            Se puede elegir turno, pero no ficha. Es decir, tanto si empieza la CPU, como   ||                -}
{-                ||            la persona que juegue, se le asignará la ficha X (y al otro jugador, la O).     ||                -}
{-                ||        · FINALIDAD:                                                                        ||                -}
{-                ||            La meta del juego es hacer una raya con 3 fichas, bien sea mediante             ||                -}
{-                ||            una línea horizontal, vertical o diagonal.                                      ||                -}
{-                ||            - GANAR:                                                                        ||                -}
{-                ||                Quien antes la haga, se llevará la victoria.                                ||                -}
{-                ||            - EMPATAR:                                                                      ||                -}
{-                ||                Si el tablero se ha llenado por completo de X's y O's pero ninguno          ||                -}
{-                ||                de los jugadores ha conseguido hacer una raya, se considerará empate.       ||                -}
{-                ||============================================================================================||                -}
{-                ""                                                                                            ""                -}
{----------------------------------------------------------------------------------------------------------------------------------}


{----------------------------------------------------------------------------------------------------------------------------------}
{-                                                __                           __                                                 -}
{-                                                ||===========================||                                                 -}
{-                                                ||     OPCIONES DE JUEGO     ||                                                 -}
{-                                                ||===========================||                                                 -}
{-                                                ""                           ""                                                 -}
{-                __                                                                                            __                -}
{-                ||============================================================================================||                -}
{-                ||    · ELEGIR QUIÉN EMPIEZA:                                                                 ||                -}
{-                ||        Se puede elegir quién empieza antes de comenzar a jugar, si poner la primera ficha  ||                -}
{-                ||        o dejar que sea la CPU quien la ponga primero.                                      ||                -}
{-                ||    · GUARDAR PARTIDA:                                                                      ||                -}
{-                ||        Se puede Guardar la partida en un fichero de texto aparte para, después, cargarla.  ||                -}
{-                ||    · CARGAR PARTIDA:                                                                       ||                -}
{-                ||        Se puede Cargar una partida antigua con sólo poner el nombre con el que se guardó   ||                -}
{-                ||        y así poder volver a jugar desde el punto en que se dejó.                           ||                -}
{-                ||============================================================================================||                -}
{-                ""                                                                                            ""                -}
{----------------------------------------------------------------------------------------------------------------------------------}


import Data.List
import System.IO

 
{---------------------------------------------------------------------------------------------------------------------}
{-                           __                                                         __                           -}
{-                           ||=========================================================||                           -}
{-                           ||     DECLARACIÓN DE NUEVOS TIPOS Y SINÓNIMOS DE TIPO     ||                           -}
{-                           ||=========================================================||                           -}
{-          __               ""                                                         ""               __          -}
{-          ||===========================================================================================||          -}
{-          ||        Con el fin de facilitar la implementación y la comprensión de las funciones        ||          -}
{-          ||             que se usarán posteriormente, se procede a declarar tipos nuevos.             ||          -}
{-          ||===========================================================================================||          -}
{-          ""                                                                                           ""          -}
{---------------------------------------------------------------------------------------------------------------------}



{-   __              __                                                                                              -}
{-   ||==============||                                                                                              -}
{-   ||   Posición   ||                                                                                              -}
{-   ||==============||                                                                                              -}
{-   ""              ""                                                                                              -}
{-           _____________________________________________________________________                                   -}
{-          |                                                                     |                                  -}
{-          |    El (sinónimo de) tipo "Posicion" nos servirá para identificar    |                                  -}
{-          |    cada una de las 9 posiciones del tablero de las "3 en Raya"      |                                  -}
{-          |_____________________________________________________________________|                                  -}


type Posicion = Int



{-   __             __                                                                                               -}
{-   ||=============||                                                                                               -}
{-   ||   Jugador   ||                                                                                               -}
{-   ||=============||                                                                                               -}
{-   ""             ""                                                                                               -}
{-           _________________________________________________________________________________                       -}
{-          |                                                                                 |                      -}
{-          |    El nuevo tipo "Jugador" nos bastará para poder diferenciar entre la CPU y    |                      -}
{-          |    el Humanoide que ose desafiarla. Lo haremos mediante 3 constructores:        |                      -}
{-          |        ·  X: Será el símbolo de la ficha del Jugador que juegue primero         |                      -}
{-          |        ·  O: Será el símbolo de la ficha del Jugador que juegue segundo         |                      -}
{-          |        ·  V: Será el símbolo que indique si una posición está "vacía",          |                      -}
{-          |        ·     es decir, si aún no se ha colocado una ficha en ella.              |                      -}
{-          |_________________________________________________________________________________|                      -}


data Jugador = X | O | V                                                                          
    deriving (Show, Read, Eq)                                                                     



{-   __            __                                                                                                -}
{-   ||============||                                                                                                -}
{-   ||   Jugada   ||                                                                                                -}
{-   ||============||                                                                                                -}
{-   ""            ""                                                                                                -}
{-           __________________________________________________________________________                              -}
{-          |                                                                          |                             -}
{-          |    El tipo "Jugada" nos valdrá para asociar a cada posición del          |                             -}
{-          |    tablero el jugador que ha colocado una ficha en dicha posición        |                             -}
{-          |    Obviamente, será:                                                     |                             -}
{-          |        · (X/O) si ha colocado alguien                                    |                             -}
{-          |        · (V)   en caso contrario                                         |                             -}
{-          |__________________________________________________________________________|                             -}


type Jugada = (Posicion, Jugador)



{-   __             __                                                                                               -}
{-   ||=============||                                                                                               -}
{-   ||   Tablero   ||                                                                                               -}
{-   ||=============||                                                                                               -}
{-   ""             ""                                                                                               -}
{-          _________________________________________________________________________                                -}
{-          |                                                                         |                              -}
{-          |    El tipo "Tablero" representará la colección de todas las Jugadas,    |                              -}
{-          |    es decir, será una lista formada por todas esas duplas.              |                              -}
{-          |_________________________________________________________________________|                              -}


data Tablero = Tab [Jugada]
    deriving (Show, Read)







{---------------------------------------------------------------------------------------------------------------------}
{-                                __                                               __                                -}
{-                                ||===============================================||                                -}
{-                                ||     REPRESENTACIÓN Y ESTÉTICA DEL TABLERO     ||                                -}
{-                                ||===============================================||                                -}
{-                                ""                                               ""                                -}
{---------------------------------------------------------------------------------------------------------------------}



{-   __                     __                                                                                       -}
{-   ||=====================||                                                                                       -}
{-   ||   Tablero Inicial   ||                                                                                       -}
{-   ||=====================||                                                                                       -}
{-   ""                     ""                                                                                       -}
{-           ________________________________________________________________________________                        -}
{-          |                                                                                |                       -}
{-          |    Crea un tablero en el que no se ha colocado aún ninguna ficha, es decir:    |                       -}
{-          |          Tab [(1,V),(2,V),(3,V),(4,V),(5,V),(6,V),(7,V),(8,V),(9,V)]           |                       -}
{-          |________________________________________________________________________________|                       -}


tableroVirgen :: Tablero
tableroVirgen = Tab [ (x,V) | x <- [1..9] ]



{-   __                          __                                                                                  -}
{-   ||==========================||                                                                                  -}
{-   ||   Estética del Tablero   ||                                                                                  -}
{-   ||==========================||                                                                                  -}
{-   ""                          ""                                                                                  -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    FUNCIÓN PRINCIPAL:                                                                  |               -}
{-          |                                                                                        |               -}
{-          |        · tableroEsthetic                                                               |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero                                                             |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 El Tablero que ha recibido, pero bajo la Clase String, es decir,       |               -}
{-          |                 muestra el Tablero con la estética que se le ha dado.                  |               -}
{-          |                                                                                        |               -}
{-          |    FUNCIONES QUE INTERVIENEN:                                                          |               -}
{-          |                                                                                        |               -}
{-          |        · casillas                                                                      |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero y una Posición.                                             |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Ese Tablero pero, si en la Posición se ha puesto una ficha             |               -}
{-          |                 (ya sea X u O), en esa misma posición pone "X" u "O".                  |               -}
{-          |                 Si no se ha puesto ninguna ficha, devuelve sólo la Posición,           |               -}
{-          |                 es decir, el número de la casilla en el Tablero.                       |               -}
{-          |                                                                                        |               -}
{-          |                      ----------------- EJEMPLO: ----------------                       |               -}
{-          |                                   =================                                    |               -}
{-          |                                   || X || 2 || O ||                                    |               -}
{-          |                                   ||===||===||===||                                    |               -}
{-          |                                   || O || 5 || X ||                                    |               -}
{-          |                                   ||===||===||===||                                    |               -}
{-          |                                   || X || O || 9 ||                                    |               -}
{-          |                                   =================                                    |               -}
{-          |________________________________________________________________________________________|               -}


tableroEsthetic :: Tablero -> String
tableroEsthetic t =
    "       =================\n"   ++
    "       || " ++ (casillas t 1) ++ " || " ++ (casillas t 2) ++ " || " ++ (casillas t 3) ++ " ||\n" ++
    "       ||===||===||===||\n"   ++
    "       || " ++ (casillas t 4) ++ " || " ++ (casillas t 5) ++ " || " ++ (casillas t 6) ++ " ||\n" ++
    "       ||===||===||===||\n"   ++
    "       || " ++ (casillas t 7) ++ " || " ++ (casillas t 8) ++ " || " ++ (casillas t 9) ++ " ||\n" ++
    "       =================\n"

casillas :: Tablero -> Posicion -> String
casillas (Tab xs) pos
    | snd (xs !! (pos - 1)) /= V = show (snd (xs !! (pos - 1)))
    | otherwise                  = show (pos)







{---------------------------------------------------------------------------------------------------------------------}
{-                                __                                               __                                -}
{-                                ||===============================================||                                -}
{-                                ||               TURNOS Y JUGADAS                ||                                -}
{-                                ||===============================================||                                -}
{-                                ""                                               ""                                -}
{---------------------------------------------------------------------------------------------------------------------}



{-   __              __                                                                                              -}
{-   ||==============||                                                                                              -}
{-   ||    Turnos    ||                                                                                              -}
{-   ||==============||                                                                                              -}
{-   ""              ""                                                                                              -}
{-           ___________________________________________________________________________________________             -}
{-          |                                                                                           |            -}
{-          |    FUNCIÓN PRINCIPAL:                                                                     |            -}
{-          |                                                                                           |            -}
{-          |        · turnoDeWho                                                                       |            -}
{-          |            - RECIBE:                                                                      |            -}
{-          |                 Un Tablero.                                                               |            -}
{-          |            - DEVUELVE:                                                                    |            -}
{-          |                 El Jugador al que le corresponde mover en esa situación de la partida:    |            -}
{-          |                     · Si hay más X's que O's: le toca al Jugador que lleva las X.         |            -}
{-          |                     · En caso contrario:      le toca al Jugador que lleva las 0.         |            -}
{-          |                 (estamos presuponiendo que siempre empieza el jugador que lleva las X).   |            -}
{-          |___________________________________________________________________________________________|            -}

turnoDeWho :: Tablero -> Jugador
turnoDeWho (Tab xs)
    | nX > nO   = O  
    | otherwise = X
    where nX = length (filter (== X) (map (snd) xs))     {- nX:   Número de fichas X -}
          nO = length (filter (== O) (map (snd) xs))     {- nO:   Número de fichas O -}



{-   __               __                                                                                             -}
{-   ||===============||                                                                                             -}
{-   ||    Jugadas    ||                                                                                             -}
{-   ||===============||                                                                                             -}
{-   ""               ""                                                                                             -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    FUNCIONES PRINCIPALES:                                                              |               -}
{-          |                                                                                        |               -}
{-          |        · jugadasDeX                                                                    |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero.                                                            |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Una Lista de enteros que representan las casillas que han sido         |               -}
{-          |                 ocupadas por el jugador que lleva las fichas X.                        |               -}
{-          |                                                                                        |               -}
{-          |        · jugadasDeO                                                                    |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero.                                                            |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Una Lista de enteros que representan las casillas que han sido         |               -}
{-          |                 ocupadas por el jugador que lleva las fichas O.                        |               -}
{-          |                                                                                        |               -}
{-          |        · casillasLibres                                                                |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero.                                                            |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Una Lista de enteros que representan las casillas que aún NO           |               -}
{-          |                 han sido ocupadas por ninguno de los dos jugadores.                    |               -}
{-          |________________________________________________________________________________________|               -}


jugadasDeX :: Tablero -> [Int]
jugadasDeX (Tab xs) = map (fst) (filter (\(p,j) -> j == X) xs)

jugadasDeO :: Tablero -> [Int]
jugadasDeO (Tab xs) = map (fst) (filter (\(p,j) -> j == O) xs)

casillasLibres :: Tablero -> [Int]
casillasLibres (Tab xs) = map (fst) (filter (\(p,j) -> j == V) xs)







{---------------------------------------------------------------------------------------------------------------------}
{-                                __                                               __                                -}
{-                                ||===============================================||                                -}
{-                                ||               ESTADO DEL JUEGO:               ||                                -}
{-                                ||===============================================||                                -}
{-                                ""                                               ""                                -}
{---------------------------------------------------------------------------------------------------------------------}



{-   __            __                                                                                                -}
{-   ||============||                                                                                                -}
{-   ||    Raya    ||                                                                                                -}
{-   ||============||                                                                                                -}
{-   ""            ""                                                                                                -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    FUNCIÓN PRINCIPAL:                                                                  |               -}
{-          |                                                                                        |               -}
{-          |        · hayRaya                                                                       |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero.                                                            |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Un Booleano en función de si en ese Tablero se ha cantado Raya o no.   |               -}
{-          |                                                                                        |               -}
{-          |    FUNCIONES QUE INTERVIENEN:                                                          |               -}
{-          |                                                                                        |               -}
{-          |        · esListaContenida                                                              |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Dos Listas de Enteros.                                                 |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Un Booleano en función de si la segunda lista está contenida en la     |               -}
{-          |                 primera.                                                               |               -}
{-          |                 Esto es con la finalidad de ver si se ha hecho alguna Raya en las      |               -}
{-          |                 jugadas de X o en las jugadas de O.                                    |               -}
{-          |                                                                                        |               -}
{-          |        · rayas                                                                         |               -}
{-          |            - FINALIDAD:                                                                |               -}
{-          |                 Es una manera rápida de definir/implementar (bajo una Lista de Listas) |               -}
{-          |                 todas las Rayas que se pueden hacer en el juego de las "3 en Raya"     |               -}
{-          |________________________________________________________________________________________|               -}


hayRaya :: Tablero -> Bool
hayRaya t = (or (map (eLC (jX)) rayas)) || (or (map (eLC (jO)) rayas))
                where eLC = esListaContenida
                      jX  = jugadasDeX t 
                      jO  = jugadasDeO t

                {- (map (eLC (jX)) rayas):    (análogo para jO)                 -}
                {-          FINALIDAD: Saber si hay Raya entre las jugadas de X -}
                {-          DEVUELVE:  Una lista de booleanos en función de si  -}
                {-               alguna de las "Rayas" está en las jugadas de X -}

esListaContenida :: [Int] -> [Int] -> Bool
esListaContenida (xs) (y:ys)
    | elem y xs = esListaContenida xs ys
    | otherwise = False
esListaContenida _ [] = True

rayas :: [[Int]]
rayas = [[1,2,3], [4,5,6], [7,8,9],    {- HORIZONTALES -}
         [1,4,7], [2,5,8], [3,6,9],    {-  VERTICALES  -}
         [1,5,9], [3,5,7]]             {-  DIAGONALES  -}



{-   __                     __                                                                                       -}
{-   ||=====================||                                                                                       -}
{-   ||     Hay Ganador     ||                                                                                       -}
{-   ||=====================||                                                                                       -}
{-   ""                     ""                                                                                       -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    FUNCIÓN PRINCIPAL:                                                                  |               -}
{-          |                                                                                        |               -}
{-          |        · ganadorMundial                                                                |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero.                                                            |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Un Jugador:                                                            |               -}
{-          |                     Ha ganado el Jugador que lleva las fichas X ---> X                 |               -}
{-          |                     Ha ganado el Jugador que lleva las fichas O ---> O                 |               -}
{-          |                     Aún no ha ganado ninguno de los dos         ---> V                 |               -}
{-          |________________________________________________________________________________________|               -}


ganadorMundial :: Tablero -> Jugador
ganadorMundial t
    | hayRaya t && (or (map (esListaContenida (jugadasDeX t)) rayas)) = X
    | hayRaya t && (or (map (esListaContenida (jugadasDeO t)) rayas)) = O
    | otherwise = V



{-   __                      __                                                                                      -}
{-   ||======================||                                                                                      -}
{-   ||    Fin de Partida    ||                                                                                      -}
{-   ||======================||                                                                                      -}
{-   ""                      ""                                                                                      -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    FUNCIÓN PRINCIPAL:                                                                  |               -}
{-          |        · seAcabo                                                                       |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 Un Tablero.                                                            |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Un Booleano:                                                           |               -}
{-          |                     Si hay una Raya o el Tablero está Completo   ---> True             |               -}
{-          |                     Si no ocurre ninguna de esas dos situaciones ---> False            |               -}
{-          |________________________________________________________________________________________|               -}


seAcabo :: Tablero -> Bool
seAcabo t = (tableroLleno t) || (hayRaya t)
    where tableroLleno t = (casillasLibres t == [])







{---------------------------------------------------------------------------------------------------------------------}
{-                                __                                              __                                 -}
{-                                ||==============================================||                                 -}
{-                                ||      ALGORITMO MINIMAX E IMPLEMENTACIÓN      ||                                 -}
{-                                ||==============================================||                                 -}
{-                                ""                                              ""                                 -}
{---------------------------------------------------------------------------------------------------------------------}



{-   __                            __                                                                                -}
{-   ||============================||                                                                                -}
{-   ||    MinimaxMain y Minimax   ||                                                                                -}
{-   ||============================||                                                                                -}
{-   ""                            ""                                                                                -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    FUNCIÓN PRINCIPAL:                                                                  |               -}
{-          |                                                                                        |               -}
{-          |        · minimaxMain                                                                   |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 · Profundidad (prof):                                                  |               -}
{-          |                     La profundidad de búsqueda del algoritmo Minimax. Está             |               -}
{-          |                     inicializada en 6 porque con 6 fichas puestas el Tablero ya        |               -}
{-          |                     estaría decidido.                                                  |               -}
{-          |                         - Con Profundidad 6: la CPU nunca pierde.                      |               -}
{-          |                         - Con profundidad 2: es posible ganar a la CPU porque su       |               -}
{-          |                                              nivel de análisis es sólo con vistas a    |               -}
{-          |                                              dos futuras jugadas.                      |               -}
{-          |                 · Expandir (expandir):                                                 |               -}
{-          |                     Esta función se encarga de devolver, a partir de un tablero        |               -}
{-          |                     dado, una lista con todos los tableros fruto de realizar una       |               -}
{-          |                     futura jugada. Es decir, cuando hay dos fichas puestas, hay 7      |               -}
{-          |                     huecos libres, por lo tanto, la lista contendrá 7 tableros.        |               -}
{-          |                 · Evaluar (evaluar):                                                   |               -}
{-          |                     La finalidad de esta función es asociar a cada Tablero un valor    |               -}
{-          |                     positivo (+1) si es beneficiosos para el jugador que sea su        |               -}
{-          |                     turno o, en caso contrario, negativo si es perjudicial para el     |               -}
{-          |                     jugador que goce del turno.                                        |               -}
{-          |                     Por este razonamiento, es lógico pensar que, a su vez, ésta        |               -}
{-          |                     se desmembre en dos funciones, dependiendo de si:                  |               -}
{-          |                         - es el turno del jugador que lleva las X:    evaluarX         |               -}
{-          |                         - es el turno del jugador que lleva las O:    evaluarO         |               -}
{-          |                 · Problemática (probl):                                                |               -}
{-          |                     En nuestro caso, la "problemática" es un Tablero. En este caso,    |               -}
{-          |                     este parámetro será el Tablero que se someta al algoritmo, es      |               -}
{-          |                     decir, el que tendrá que analizar la CPU en cada jugada.           |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Un Tablero con el mejor movimiento posible en ese estado de la         |               -}
{-          |                 partida.                                                               |               -}
{-          |                 El Tablero Final no será más que un Tablero donde se ha puesto         |               -}
{-          |                 una ficha más con respecto al Tablero de Entrada. Pero esa ficha es    |               -}
{-          |                 la mejor elección para el beneficio de la CPU.                         |               -}
{-          |                                                                                        |               -}
{-          |    FUNCIONES QUE INTERVIENEN:                                                          |               -}
{-          |                                                                                        |               -}
{-          |        · minimax                                                                       |               -}
{-          |            - RECIBE:                                                                   |               -}
{-          |                 · Profundidad (prof)                                                   |               -}
{-          |                 · Expandir (expandir)                                                  |               -}
{-          |                 · Evaluar (evaluar)                                                    |               -}
{-          |                 · Peor/Mejor (peor/mejor):                                             |               -}
{-          |                     - maximum':                                                        |               -}
{-          |                         Calcula el máximo de una lista de tuplas "[(Int, Tablero)]"    |               -}
{-          |                         para saber cuál es el "mejor" Tablero que ha de elegirse.      |               -}
{-          |                     - maximum':                                                        |               -}
{-          |                         Calcula el mínimo de una lista de tuplas "[(Int, Tablero)]"    |               -}
{-          |                         para saber cuál es el "peor" Tablero que ha de elegirse.       |               -}
{-          |                                                                                        |               -}
{-          |                     Tanto Peor como Mejor son funciones que se inicializan con las     |               -}
{-          |                     dos definidas previamente (maximum' y minimum'). Pero en la        |               -}
{-          |                     función "minimax" están al revés por la siguiente razón:           |               -}
{-          |                                                                                        |               -}
{-          |                      "El movimiento que es bueno para el Jugador, es malo para la CPU" |               -}
{-          |                                            (y viceversa)                               |               -}
{-          |                 · Problemática (probl)                                                 |               -}
{-          |            - DEVUELVE:                                                                 |               -}
{-          |                 Una dupla (Int, Tablero), resultado de haber visualizado todas las     |               -}
{-          |                 posibles futuras jugadas del Tablero y haber elegido la más óptima     |               -}
{-          |                 en ese estado de la partida.                                           |               -}
{-          |                                                                                        |               -}
{-          |    DEFINICIÓN DE NUEVO TIPO:                                                           |               -}
{-          |                                                                                        |               -}
{-          |        · Valutazione:                                                                  |               -}
{-          |            Con la definición de este nuevo tipo se pretende asociar a cada tablero su  |               -}
{-          |            evaluación, es decir:                                                       |               -}
{-          |                                                                                        |               -}
{-          |                (Int, Tablero)                                                          |               -}
{-          |                                                                                        |               -}
{-          |            Con vistas a las funciones " maximum'/minimum' " y " mejor/peor " y así     |               -}
{-          |            poder comparar directamente si un tablero es más beneficioso que otro.      |               -}
{-          |                                                                                        |               -}
{-          |                                                                                        |               -}
{-          |________________________________________________________________________________________|               -}


minimaxMain :: Ord b => (Int) -> (a -> [a]) -> (a -> (a -> (b,a))) -> a -> a
minimaxMain             (prof)   (expandir)         (evaluar)      (probl)
   | (prof == 0) || (null siguientes) = probl
   | otherwise                        = snd (maximum' valoraciones)
    where siguientes   = expandir probl
          valoraciones = map (minimax (prof - 1) expandir (evaluar probl) maximum' minimum') siguientes



minimax :: Ord b => (Int) -> (a -> [a]) -> (a -> (b,a)) -> ([(b,a)] -> (b,a)) -> ([(b,a)] -> (b,a)) -> a -> (b,a)
minimax             (prof)   (expandir)     (evaluar)             (peor)               (mejor)      (probl)
   | (prof == 0) || (null siguientes) = (evaluar probl)
   | otherwise                        = (fst (mejor (map (miniM) siguientes)), probl)
    where siguientes = expandir probl
          miniM      = minimax (prof - 1) (expandir) (evaluar) (mejor) (peor)



{-   __                     __                                                                                       -}
{-   ||=====================||                                                                                       -}
{-   ||     Profundidad     ||                                                                                       -}
{-   ||=====================||                                                                                       -}
{-   ""                     ""                                                                                       -}


profunditat :: Int
profunditat = 6



{-   __                __                                                                                            -}
{-   ||================||                                                                                            -}
{-   ||    Expandir    ||                                                                                            -}
{-   ||================||                                                                                            -}
{-   ""                ""                                                                                            -}


expandir :: Tablero -> [Tablero]
expandir t
    | seAcabo t = []
    | otherwise      = map (futuraJugada t) (casillasLibres t)

    {- Como siempre empieza X y hay 9 Huecos, siempre que queden -}
    {-      Huecos Impares: Le toca jugar a X                    -}
    {-      Huecos Pares:   Le toca jugar a O                    -}
futuraJugada :: Tablero -> Posicion -> Tablero
futuraJugada (Tab xs) pos
    | odd (length (casillasLibres (Tab xs))) = Tab (futuraFicha (pos,X) xs)
    | otherwise                            = Tab (futuraFicha (pos,O) xs)


futuraFicha :: Jugada -> [Jugada] -> [Jugada]
futuraFicha j (x:xs)
    | fst j == fst x = ( j : xs )
    | otherwise      =   x : futuraFicha j xs



{-   __               __                                                                                             -}
{-   ||===============||                                                                                             -}
{-   ||    Evaluar    ||                                                                                             -}
{-   ||===============||                                                                                             -}
{-   ""               ""                                                                                             -}


type Valutazione = (Int, Tablero)

evaluar :: Tablero -> (Tablero -> Valutazione)
evaluar t
    | (turnoDeWho t == X) = evaluarX 
    | otherwise           = evaluarO

evaluarX :: Tablero -> Valutazione
evaluarX t
    | (ganadorMundial t == X) = ( 1, t )
    | (ganadorMundial t == O) = (-1, t )
    | otherwise               = ( 0, t )

evaluarO :: Tablero -> Valutazione
evaluarO t
    | (ganadorMundial t == O) = ( 1, t )
    | (ganadorMundial t == X) = (-1, t )
    | otherwise               = ( 0, t )



{-   __                                    __                                                                        -}
{-   ||====================================||                                                                        -}
{-   ||    Maximum/Minimum (Mejor/Peor)    ||                                                                        -}
{-   ||====================================||                                                                        -}
{-   ""                                    ""                                                                        -}


maximum' :: Ord a => [(a,b)] -> (a,b)
maximum' [x] = x
maximum' (x:y:zs)
    | fst x >= fst y = maximum' (x:zs)
    | otherwise      = maximum' (y:zs)

minimum' :: Ord a => [(a,b)] -> (a,b)
minimum' [x] = x
minimum' (x:y:zs)
    | fst x <= fst y = minimum' (x:zs)
    | otherwise      = minimum' (y:zs)







{---------------------------------------------------------------------------------------------------------------------}
{-                                __                                               __                                -}
{-                                ||===============================================||                                -}
{-                                ||         FUNCIONES DE ENTRADA Y SALIDA         ||                                -}
{-                                ||===============================================||                                -}
{-                                ""                                               ""                                -}
{---------------------------------------------------------------------------------------------------------------------}



{-   __                         __                                                                                   -}
{-   ||=========================||                                                                                   -}
{-   ||    Función Principal    ||                                                                                   -}
{-   ||=========================||                                                                                   -}
{-   ""                         ""                                                                                   -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    DESCRIPCIÓN:                                                                        |               -}
{-          |                                                                                        |               -}
{-          |        La función principal (main) es con la que se inicia el juego.                   |               -}
{-          |                                                                                        |               -}
{-          |        Consta de varias partes (funciones) que se van llamando unas a otras y darle    |               -}
{-          |        así al juego cierta fluidez para que no sea únicamente movimientos de la CPU    |               -}
{-          |        contra movimientos del Jugador:                                                 |               -}
{-          |            · main:                                                                     |               -}
{-          |                La primera de las partes plantea al Jugador si quiere iniciar el juego  |               -}
{-          |                de una forma muy simpática.                                             |               -}
{-          |            · menu:                                                                     |               -}
{-          |                La segunda parte es un menú que da a elegir al Jugador si empezar       |               -}
{-          |                poniendo ficha o no, o si querría cargar una partida antigua que se     |               -}
{-          |                guardó previamente.                                                     |               -}
{-          |            · humanoide/maquinita:                                                      |               -}
{-          |                Estas dos funciones conforman la tercera parte del juego. Son las dos   |               -}
{-          |                que se van a estar llamando recursivamente para poder jugar los turnos  |               -}
{-          |                hasta que llegue el momento en el que se acabe la partida.              |               -}
{-          |            · volverAJugar:                                                             |               -}
{-          |                Esta cuarta y última parte cierra las funciones IO del juego dando la   |               -}
{-          |                posibilidad al jugador de volver a iniciar el juego una vez se ha       |               -}
{-          |                acabado la partida.                                                     |               -}
{-          |                                                                                        |               -}
{-          |                                                                                        |               -}
{-          |            · Cargar una partida (que se haya guardado previamente)                     |               -}
{-          |________________________________________________________________________________________|               -}


main :: IO () 
main = do putStrLn "\n\n\n¿Acaso cree poder ganar a un ordenador en 2021 al 3enRaya?\n"
          putStrLn "        1) Sí, soy Jesucristo"
          putStrLn "        2) Habiendo inventado la Roomba, ¿quién soy yo para retar a un ordenador?\n"
          putStr   "        Su respuesta es: "
          respuesta <- getRespuesta
          case respuesta of
              1 -> do menu
              2 -> putStrLn "        Humanoide humilde, quedáis pocos. Suerte en la vida."
              otherwise -> putStrLn "        A ver, ¿me puede hacer el favor de poner 1 ó 2?"



{-   __            __                                                                                                -}
{-   ||============||                                                                                                -}
{-   ||    Menu    ||                                                                                                -}
{-   ||============||                                                                                                -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    DESCRIPCIÓN:                                                                        |               -}
{-          |                                                                                        |               -}
{-          |        Menú (menu) es una función de entrada/salida cuya intención es, una vez         |               -}
{-          |        inicializado el juego, se dé a elegir al Jugador tres opciones:                 |               -}
{-          |            · Jugar Primero                                                             |               -}
{-          |            · Jugar Segundo                                                             |               -}
{-          |            · Cargar una partida (que se haya guardado previamente)                     |               -}
{-          |________________________________________________________________________________________|               -}


menu :: IO()
menu = do putStrLn "\n        1. ¿Desea jugar primero?"
          putStrLn "        2. ¿Desea jugar segundo?"
          putStrLn "        3. ¿Quiere cargar una antigua partida? \n"
          putStr   "        Su respuesta es: "
          eleccion <- getRespuesta
          case eleccion of
              1 -> do putStrLn "\nBien, pues aquí tenéis, usted y su osadía, vuestro tablero: \n"
                      putStrLn (tableroEsthetic tableroVirgen)
                      humanoide tableroVirgen
              2 -> do putStrLn "\nBien, pues aquí tenéis, usted y su osadía, vuestro tablero: \n"
                      putStrLn (tableroEsthetic tableroVirgen)
                      maquinita tableroVirgen
              3 -> do partidaAntigua <- cargarPartida
                      putStrLn "\n        Aquí tiene, desde donde la dejó, su antigua partida: \n"
                      putStrLn (tableroEsthetic partidaAntigua)
                      humanoide partidaAntigua
              otherwise -> putStrLn "        ¿Le importaría elegir, si es tan amable, uno de esos tres numeritos?"



{-   __                   __                                                                                         -}
{-   ||===================||                                                                                         -}
{-   ||    Ahorrar read   ||                                                                                         -}
{-   ||===================||                                                                                         -}
{-   ""                   ""                                                                                         -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    DESCRIPCIÓN:                                                                        |               -}
{-          |                                                                                        |               -}
{-          |        Se crea esta función con la finalidad de leer un entero y así no estar          |               -}
{-          |        utilizando constantemente la función "read"                                     |               -}
{-          |________________________________________________________________________________________|               -}


getRespuesta :: IO Int
getRespuesta = do c <- getLine
                  return (read c)



{-   __                        __                                                                                    -}
{-   ||========================||                                                                                    -}
{-   ||    Turno del Jugador   ||                                                                                    -}
{-   ||========================||                                                                                    -}
{-   ""                        ""                                                                                    -}
{-           ________________________________________________________________________________________                -}
{-          |                                                                                        |               -}
{-          |    DESCRIPCIÓN:                                                                        |               -}
{-          |                                                                                        |               -}
{-          |        Esta función (humanoide) de entrada/salida es la encargada de dar el turno al   |               -}
{-          |        Jugador para colocar su ficha.                                                  |               -}
{-          |                                                                                        |               -}
{-          |        Pero no sólo eso, también da la opción, mientras sea su turno, de poder cargar  |               -}
{-          |        una partida antigua (guardada previamente).                                     |               -}
{-          |                                                                                        |               -}
{-          |        El funcionamiento de "humanoide", para poder dar la fluidez al juego, no sólo   |               -}
{-          |        da el turno al jugador, sino que evalúa el estado de la partida para ver si     |               -}
{-          |        tiene que finalizar la partida o proseguirla cediéndole el turno a la CPU.      |               -}
{-          |________________________________________________________________________________________|               -}


humanoide :: Tablero -> IO()
humanoide t = do putStr "\n        ¿Dónde desea colocar su ficha? "
                 putStrLn "(Recuerde que pulsando 0 puede guardar su partida)\n"
                 putStr   "        Su elección es: "
                 jugadita <- getRespuesta
                 case jugadita of
                     0         -> do guardarPartida t
                                     putStrLn "\n        La partida ha sido guardada correctamente\n"
                                     putStr   "        Teclée 'main' y "
                                     putStrLn "seleccione la opción 3 para jugar desde este punto.\n"
                     otherwise -> do if ( elem (jugadita) (casillasLibres t) )
                                        then do putStrLn "\nUsted ha jugado: \n"  -- Sujeto a estética
                                                let fTab = futuraJugada t jugadita
                                                putStrLn (tableroEsthetic fTab)
                                                if seAcabo fTab
                                                   then if hayRaya fTab
                                                           then do putStr   "\n        Enhorabuena, "
                                                                   putStrLn "pero nadie daba un duro por ti \n"
                                                                   volverAJugar
                                                        else do putStrLn "\n        Casi, pero empató.\n"
                                                                putStr   "\n        Honestamente, es lo máximo "
                                                                putStrLn "a lo que aspirabas, Humano \n"
                                                                volverAJugar
                                                else do maquinita fTab
                                     else do putStr   "\n        No es tan difícil poner un numerito..., "
                                             putStrLn "anda, teclée de nuevo"
                                             humanoide t



{-   __                          __                                                                                  -}
{-   ||==========================||                                                                                  -}
{-   ||    Turno del Ordenador   ||                                                                                  -}
{-   ||==========================||                                                                                  -}
{-   ""                          ""                                                                                  -}


maquinita :: Tablero -> IO()
maquinita t = do putStrLn "Steve Jobs, desde donde esté, ha jugado: \n"
                 let fTab = minimaxMain (profunditat) (expandir) (evaluar) (t)
                 putStrLn (tableroEsthetic fTab)
                 if seAcabo fTab
                    then if hayRaya fTab
                            then do putStrLn "Vaya, nadie se esperaba que ganara la maquinita\n"
                                    volverAJugar
                         else do putStrLn "Era lo único mejor que perder: empatar. \n"
                                 volverAJugar
                 else do humanoide fTab



{-   __                      __                                                                                      -}
{-   ||======================||                                                                                      -}
{-   ||    Volver a Jugar    ||                                                                                      -}
{-   ||======================||                                                                                      -}
{-   ""                      ""                                                                                      -}


volverAJugar :: IO()
volverAJugar = do putStrLn "        1) ¿Desea intentarlo otra vez?"
                  putStrLn "        2) ¿o ya se ha convencido de que, a lo sumo, empatará?\n"
                  putStr   "        Su respuesta es: "
                  contesta <- getRespuesta 
                  case contesta of
                      1         -> do main
                      2         -> putStrLn "\n        Sabia decisión, Humano. Hasta otra."
                      otherwise -> putStrLn "\n        No se frustre, tan sólo era elegir entre 1 ó 2."



{-   __                               __                                                                             -}
{-   ||===============================||                                                                             -}
{-   ||    Guardar y Cargar Partida   ||                                                                             -}
{-   ||===============================||                                                                             -}
{-   ""                               ""                                                                             -}


guardarPartida :: Tablero -> IO()
guardarPartida t = do putStr "\n        ¿Qué nombre desea poner al archivo? "
                      nombrePartida <- getLine
                      writeFile nombrePartida (show(t))

cargarPartida :: IO Tablero
cargarPartida = do putStr "\n        ¿Con qué nombré guardó la antigua partida? "
                   nombreAntigua <- getLine
                   contenido <- readFile nombreAntigua
                   return (read contenido::Tablero)


