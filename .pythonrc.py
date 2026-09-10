from sympy import *
from sympy.abc import x, y, z, t
import pint
ureg = pint.UnitRegistry()
Q_ = ureg.Quantity
init_printing()  # pretty-prints expressions via unicode/latex
