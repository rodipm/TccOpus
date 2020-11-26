; ModuleID = ""
target triple = "x86_64-pc-windows-msvc"
target datalayout = ""

declare i32 @"putchar"(i32 %".1") 

define double @"putchard"(double %".1") 
{
entry:
  %"intcast" = fptoui double %".1" to i32
  %".3" = call i32 @"putchar"(i32 %"intcast")
  ret double              0x0
}

define double @"binary:"(double %"x", double %"y") 
{
entry:
  %"x.1" = alloca double
  store double %"x", double* %"x.1"
  %"y.1" = alloca double
  store double %"y", double* %"y.1"
  %"y.2" = load double, double* %"y.1"
  ret double %"y.2"
}

define double @"fibi"(double %"x") 
{
entry:
  %"i" = alloca double
  %"c" = alloca double
  %"b" = alloca double
  %"a" = alloca double
  %"x.1" = alloca double
  store double %"x", double* %"x.1"
  %"x.2" = load double, double* %"x.1"
  %"cmptmp" = fcmp ult double %"x.2", 0x4008000000000000
  %"booltmp" = uitofp i1 %"cmptmp" to double
  %".4" = fcmp one double %"booltmp",              0x0
  br i1 %".4", label %"then", label %"else"
then:
  br label %"ifcont"
else:
  store double 0x3ff0000000000000, double* %"a"
  store double 0x3ff0000000000000, double* %"b"
  store double 0x3ff0000000000000, double* %"c"
  store double 0x4008000000000000, double* %"i"
  br label %"loop"
loop:
  %"a.1" = load double, double* %"a"
  %"b.1" = load double, double* %"b"
  %"addtmp" = fadd double %"a.1", %"b.1"
  store double %"addtmp", double* %"c"
  %"b.2" = load double, double* %"b"
  store double %"b.2", double* %"a"
  %"binop" = call double @"binary:"(double %"addtmp", double %"b.2")
  %"c.1" = load double, double* %"c"
  store double %"c.1", double* %"b"
  %"binop.1" = call double @"binary:"(double %"binop", double %"c.1")
  %"i.1" = load double, double* %"i"
  %"x.3" = load double, double* %"x.1"
  %"cmptmp.1" = fcmp ult double %"i.1", %"x.3"
  %"booltmp.1" = uitofp i1 %"cmptmp.1" to double
  %"loopcond" = fcmp one double %"booltmp.1",              0x0
  %"i.2" = load double, double* %"i"
  %"nextvar" = fadd double %"i.2", 0x3ff0000000000000
  store double %"nextvar", double* %"i"
  br i1 %"loopcond", label %"loop", label %"afterloop"
afterloop:
  %"b.3" = load double, double* %"b"
  %"binop.2" = call double @"binary:"(double              0x0, double %"b.3")
  br label %"ifcont"
ifcont:
  %"iftmp" = phi double [0x3ff0000000000000, %"then"], [%"binop.2", %"afterloop"]
  ret double %"iftmp"
}

define double @"_anon1"() 
{
entry:
  %"calltmp" = call double @"fibi"(double 0x4014000000000000)
  ret double %"calltmp"
}
