import Debug.Trace ( trace )
import Data.Function ( (&) )

data Car = Car  { pass :: Int
                , maxPass :: Int
                , gas :: Int
                , maxGas :: Int
                , km :: Int
                } deriving (Eq, Show, Read)


data Op = Op { name :: String
             , result :: Bool
             } deriving (Eq, Show, Read)

data Info = Info { car :: Car
                 , op  :: Op
                 } deriving (Eq, Show, Read)


toString (Info (Car pass maxPass gas maxGas km) (Op name result)) =
                "Car pass: " ++ show pass ++ "/" ++ show maxPass
                 ++ " gas: " ++ show gas  ++ "/" ++ show maxGas
                 ++  " km: " ++ show km
                 ++ " Operation: " ++ name ++ " Result: " ++ show result

resume :: Info -> Info
resume info = trace (toString info) info

-- cria um carro passando maxPass e maxGas - retorna sempre true.
createCar :: Int -> Int -> Info
createCar x y= Info (Car 0 x 0 y 0) (Op "Create" True)

-- enche o tanque passando a qtd de gas. Retorna falso apenas se o tanque já estiver completamente cheio.
fuel :: Int -> Info -> Info
fuel x y= if (gas (car y))<(maxGas (car y)) then Info (Car (pass (car y)) (maxPass (car y)) ((gas (car y))+x) (maxGas (car y)) (km (car y))) (Op "Fuel" True) else Info (Car (pass (car y)) (maxPass (car y)) (maxGas (car y)) (maxGas (car y)) (km (car y))) (Op "Fuel" False)
-- Faz entrar uma pessoa no carro. Retorna false se já estiver lotado.
embark :: Info -> Info 
embark x = if (pass (car x))<(maxPass (car x)) then Info (Car ((pass (car x))+1) (maxPass (car x)) (gas (car x)) (maxGas (car x)) (km (car x))) (Op "Embark" True) else Info (Car (maxPass (car x)) (maxPass (car x)) (gas (car x)) (maxGas (car x)) (km (car x))) (Op "Embark" False)

-- Retira uma pessoa do carro, retorna false se não tiver ninguém no carro
disembark :: Info -> Info
disembark x = if (pass (car x))>0 then Info (Car ((pass (car x))-1) (maxPass (car x)) (gas (car x)) (maxGas (car x)) (km (car x))) (Op "Disembark" True) else Info (Car (pass (car x)) (maxPass (car x)) (gas (car x)) (maxGas (car x)) (km (car x))) (Op "Disembark" False)

-- dirige diminuindo a gasolina e aumentando km. 
-- Só é possível dirigir se houver alguém no carro e houver alguma gasolina.
-- Aumenta a km da gasolina gasta.
-- retorna false se não há ninguém no carro ou se não tinha gasolina para completar a viagem.
drive :: Int -> Info -> Info 
drive x y = if (((gas (car y))-x)>0) && (pass (car y)>0) then Info (Car (pass (car y)) (maxPass (car y)) ((gas (car y))-x) (maxGas (car y)) ((km (car y))+x)) (Op "Drive" True) else Info (Car (pass (car y)) (maxPass (car y)) (gas (car y)) (maxGas (car y)) (km (car y))) (Op "Drive" False)


--main = print $ resume . embark . resume. embark . resume $ createCar 2 50
{-main = do 
    let res = createCar 2 50 
            & resume & embark
            & resume & disembark
            & resume & disembark
            & resume & drive 10
            & resume & embark
            & resume & embark
            & resume & embark
            & resume & drive 10
            & resume & fuel 30
            & resume & fuel 30
            & resume & fuel 30
            & resume & drive 30
            & resume & drive 30
            & resume
    print res 

-}
{-
Car pass: 0/2 gas: 0/50 km: 0 Operation: create Result: True
Car pass: 1/2 gas: 0/50 km: 0 Operation: embark Result: True
Car pass: 0/2 gas: 0/50 km: 0 Operation: disembark Result: True
Car pass: 0/2 gas: 0/50 km: 0 Operation: disembark Result: False
Car pass: 0/2 gas: 0/50 km: 0 Operation: drive Result: False
Car pass: 1/2 gas: 0/50 km: 0 Operation: embark Result: True
Car pass: 2/2 gas: 0/50 km: 0 Operation: embark Result: True
Car pass: 2/2 gas: 0/50 km: 0 Operation: embark Result: False
Car pass: 2/2 gas: 0/50 km: 0 Operation: drive Result: False
Car pass: 2/2 gas: 30/50 km: 0 Operation: fuel Result: True
Car pass: 2/2 gas: 50/50 km: 0 Operation: fuel Result: True
Car pass: 2/2 gas: 50/50 km: 0 Operation: fuel Result: False
Car pass: 2/2 gas: 20/50 km: 30 Operation: drive Result: True
Car pass: 2/2 gas: 0/50 km: 50 Operation: drive Result: False
Info {car = Car {pass = 2, maxPass = 2, gas = 0, maxGas = 50, km = 50}, op = Op {name = "drive", result = False}}
-}
