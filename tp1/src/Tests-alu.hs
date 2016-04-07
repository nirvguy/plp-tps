-- Para correr los tests:
-- ghc Tests-alu.hs && ./Tests-alu

import Tp
import Test.HUnit
import Data.List

-- evaluar main para correr todos los tests
main = runTestTT allTests
texto_a_normalizar = ["abc c abc abc d", "a b a b", "abc"]
textos_a = ["b=a", "a = 2; a = 4", "C:/DOS C:/DOS/RUN RUN/DOS/RUN"]

allTests = test [
	"split"   ~: testsSplit,
	"cuentas" ~: testsCuentas,
	"longitudPromedioPalabras" ~: testLongitudPromedio,
	"repeticionesPromedio" ~: testRepeticionesPromedio,
	"frecuenciaTokens" ~: testFrecuenciaTokens,
	"normalizarExtractor" ~: testNormalizarExtractor,
	"extraerFeatures" ~: testExtraerFeatures
  ]

testsSplit = test [
	split ',' ",PLP,"        ~?= ["PLP"],
	split ',' " ,PLP, "      ~?= [" ","PLP"," "],
	split 'p' "PLP,PLP"      ~?= ["PLP,PLP"],
	split ' ' "Hola  Mundo!" ~?= ["Hola","Mundo!"]
	]

testsCuentas = test [
	cuentas ["",""]               ~?= [(2,"")],
	cuentas ["c","cc","ccc"]      ~?= [(1,"c"), (1,"cc"),(1,"ccc")],
	cuentas ["x","x","y","x","z"] ~?= [(3,"x"), (1,"y"), (1,"z")],
	cuentas ["x", "x", "x", "x"]  ~?= [(4,"x")]
	]

testLongitudPromedio = test [
	longitudPromedioPalabras ""           ~?= 0.0,
	longitudPromedioPalabras "       "    ~?= 0.0,
	longitudPromedioPalabras "a-bc,def.g" ~?= 10.0,
	longitudPromedioPalabras "a-bc def.g" ~?= 4.5,
	longitudPromedioPalabras "Este test tiene palabras $$++$$" ~?= 5.4
	]

testRepeticionesPromedio = test [
	repeticionesPromedio "" ~?= 0.0,
	repeticionesPromedio "    " ~?= 0.0,
	repeticionesPromedio "a-a b-b a-a-a" ~?= 1.0,
	repeticionesPromedio "lalala $$++$$ lalala lalala $$++$$" ~?= 2.5,
	map repeticionesPromedio texto_a_normalizar ~?= [5/3,2.0,1.0]
	]

testFrecuenciaTokens = test [
	map (\x -> x * (genericLength tokens)) [f (concat (replicate 3 tokens)) | f <- frecuenciaTokens] ~?= replicate (length tokens) 1.0,
	(head frecuenciaTokens) "use_snake_case !" ~?= 0.125
	]

testNormalizarExtractor = test [
	map (normalizarExtractor texto_a_normalizar genericLength) ("aaaaaaaaaaaaaaaa":texto_a_normalizar) ~?= [16/15,1.0,7/15,0.2],
	map (normalizarExtractor texto_a_normalizar repeticionesPromedio) ("a a a a":texto_a_normalizar) ~?= [2.0,5/6,1.0,0.5]
	]

testExtraerFeatures = test [
    extraerFeatures [longitudPromedioPalabras, repeticionesPromedio] textos_a ~?= [[0.33333334,0.6666667],[0.12962963,1.0],[1.0,0.6666667]],
  extraerFeatures [] textos_a ~?= [[],[],[]],
  extraerFeatures [genericLength] [] ~?= [],
  extraerFeatures [genericLength] ["a","ab","abc"] ~?= [[1/3], [2/3], [3/3]]
  ]
