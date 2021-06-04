
IMPLEMENTATION MODULE MathLib;
(*
	MathLib - a replacement MathLib for Turbo Modula-2. This MathLib
	uses APUlib and the AMD 9511 arithmetic processor unit.

	If the APU returns a non zero error code, the exception ArgumentError
	is raised.

	11/18/89 Wayne Hortensius
*)

FROM APUlib IMPORT APUfp2,APUfp1,APUdi2;

CONST		(* constants for all APU floating point operations *)
  ACOS  =	06H;			(* inverse cosine of A *)
  ASIN  =	05H;			(* inverse sine of A *)
  ATAN  =	07H;			(* inverse tangent of A *)
  CHSF  =	15H;			(* sign change of A *)
  COS   =	03H;			(* cosine of A *)
  EXP   =	0AH;			(* e^A function *)
  FADD  =	10H;			(* a+b *)
  FDIV  =	13H;			(* b/a *)
  FLTD  =	1CH;			(* 32 bit integer to float *)
  FLTS  =	1DH;			(* 16 bit integer to float *)
  FMUL  =	12H;			(* a*b *)
  FSUB  =	11H;			(* b-a *)
  LOG   =	08H;			(* common logarithm (base 10) of A *)
  LN    =	09H;			(* natural logarithm of A *)
  POPF  =	18H;			(* stack pop *)
  PTOF  =	17H;			(* stack push *)
  PUPI  =	1AH;			(* push pi onto stack *)
  PWR   =	0BH;			(* B^A power function *)
  SIN   =	02H;			(* sine of A *)
  SQRT  =	01H;			(* square root of A *)
  TAN   =	04H;			(* tangent of A *)
  XCHF  =	19H;			(* exchange A and B *)
  DMUL	=	2EH;			(* 32 bit integer multiply *)
  DADD	=	2CH;			(* 32 bit integer addition *)
VAR
  result : REAL;
  seed : LONGINT;
  error : INTEGER;
  
(************************************************)
(* APU functions with exact Mathlib equivalents *)
(************************************************)

(* Sqrt - square root of a *)
PROCEDURE Sqrt(a : REAL) : REAL;
BEGIN
  IF APUfp1(SQRT,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Sqrt;

(* Exp - e to the power a *)
PROCEDURE Exp(a : REAL) : REAL;
BEGIN
  IF APUfp1(EXP,a,result) <> 0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Exp;

(* Ln - natural logarithm of a *)
PROCEDURE Ln(a : REAL) : REAL;
BEGIN
  IF APUfp1(LN,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Ln;

(* Sin - sine of a (in radians) *)
PROCEDURE Sin(a : REAL) : REAL;
BEGIN
  IF APUfp1(SIN,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Sin;

(* Cos - cosine of a (in radians) *)
PROCEDURE Cos(a : REAL) : REAL;
BEGIN
  IF APUfp1(COS,a,result) <> 0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Cos;

(* Arctan - arc tangent of a *)
PROCEDURE Arctan(a : REAL) : REAL;
BEGIN
  IF APUfp1(ATAN,a,result) <> 0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Arctan;

(******************************************************)
(* MathLib procedures with no equivalent APU function *)
(******************************************************)

(* Entier - integer part of a rounded down *)
PROCEDURE Entier(a : REAL) : INTEGER;
BEGIN
  IF a<0.0 THEN
    RETURN INT(a)-1
  ELSE
    RETURN INT(a)
  END
END Entier;

(* Randomize - reseed random number generator *)
PROCEDURE Randomize(n : CARDINAL);
BEGIN
  seed := LONG(n);
END Randomize;

(* Random - return next random number *)
PROCEDURE Random() : REAL;
VAR
  longreal : LONGREAL;
  longtemp : LONGINT;
BEGIN
  longtemp := 134775813L;
  error := APUdi2(DMUL,longtemp,seed,seed);
  longtemp := 1L;
  error := APUdi2(DADD,longtemp,seed,seed);
  IF seed<0L THEN
    RETURN FLOAT((DOUBLE(seed)+4.294967296D9)/4.294967296D9)
  ELSE
    RETURN FLOAT(DOUBLE(seed)/4.294967296D9)
  END
END Random;

(*********************************************)
(* APU functions with no MathLib equivalent  *)
(*********************************************)

(* Arccos - arc cosine of a *)
PROCEDURE Arccos(a : REAL) : REAL;
BEGIN
  IF APUfp1(ACOS,a,result) <> 0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Arccos;

(* Arcsin - arc sine of a *)
PROCEDURE Arcsin(a : REAL) : REAL;
BEGIN
  IF APUfp1(ASIN,a,result) <> 0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Arcsin;

(* Fadd - add a and b *)
PROCEDURE Fadd(a,b : REAL) : REAL;
BEGIN
  IF APUfp2(FADD,a,b,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Fadd;

(* Fdiv - divide a by b *)
PROCEDURE Fdiv(a,b : REAL) : REAL;
BEGIN
  IF APUfp2(FDIV,b,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Fdiv;

(* Fmul - multiply a by b *)
PROCEDURE Fmul(a,b : REAL) : REAL;
BEGIN
  IF APUfp2(FMUL,a,b,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Fmul;

(* Fsub - subtract b from a *)
PROCEDURE Fsub(a,b : REAL) : REAL;
BEGIN
  IF APUfp2(FSUB,b,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Fsub;

(* Log - base 10 logarithm of a *)
PROCEDURE Log(a : REAL) : REAL;
BEGIN
  IF APUfp1(LOG,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Log;

(* Pwr - a to the power b *)
PROCEDURE Pwr(a,b : REAL) : REAL;
BEGIN
  IF APUfp2(PWR,b,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Pwr;

(* Tan - tangent of a (in radians) *)
PROCEDURE Tan(a : REAL) : REAL;
BEGIN
  IF APUfp1(TAN,a,result)<>0 THEN
    RAISE ArgumentError
  ELSE
    RETURN result
  END
END Tan;

BEGIN
  seed := 860098850L;	(* default random number seed *)
END MathLib.
