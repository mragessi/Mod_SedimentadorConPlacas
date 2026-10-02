SetFactory("OpenCASCADE");

/*
//---------------------------------------
// DATOS GEOMETRIA 
//---------------------------------------

W = 0.365;	//Ancho de cada canal recto
B = 0.365;	//Ancho de paso 
L = 1.260;	//Longitud de cada canal
H = 1.020;	//Altura total CCT
H1 = 0.90;	//Altura del canal
H2 = H-H1;	//Altura de la entrada
e = 0.012;	//Espesor de tabiques

*/

//---------------------------------------
// PARAMETROS FISICOS P/ DEFINIR MALLADO
//---------------------------------------

U  = 0.01;        // velocidad [m/s]
nu = 1e-6;          // viscosidad cinemática [m2/s]
yPlusTarget = 1;   // y+ deseado


Re = U*0.3/nu;			// Reynolds
Cf = 0.079*Re^(-0.25);		// Coeficiente de fricción (Blasius)
uTau = U*Sqrt(Cf/2);		// Velocidad de fricción
y1 = yPlusTarget*nu/uTau;	// Primera celda

deltaMax = 0.004;
r =1.1;

Printf("y1 = %g", y1);
Printf("deltaMax = %g", deltaMax);
Printf("progresion = %g", r);

// ----- Geometría bidimensional ----- //

x0 = 0;
y0 = 0;
z0 = 0;


incX = 147.6625; incY = 147.6625;   incZ = 5;
p[1] = newp; Point(p[1]) = {x0+incX/1000, y0+incY/1000, z0+incZ/1000, 1};

inc = 34.6751;
Translate {inc/1000, 0, 0} { Duplicata { Point{p[1]}; } }
Translate {0, inc/1000/2, 0} { Duplicata { Point{p[1]}; } }
Translate {inc/1000, inc/1000/2, 0} { Duplicata { Point{p[1]}; } }

incX = 10; incY = 10; incZ = 241;
p[5] = newp; Point(p[5]) = {x0+incX/1000, y0+incY/1000, z0+incZ/1000, 1};

inc = 310;
Translate {inc/1000, 0, 0} { Duplicata { Point{p[5]}; } }
Translate {0, inc/1000/2, 0} { Duplicata { Point{p[5]}; } }
Translate {inc/1000, inc/1000/2, 0} { Duplicata { Point{p[5]}; } }


// --------------------- Tolva --------------------- //

// --> Plano Inferor
Line(1) = {1, 2}; Line(2) = {2, 4}; Line(3) = {4, 3}; Line(4) = {3, 1};
Curve Loop(1) = {4, 1, 2, 3}; Plane Surface(1) = {1};

// --> Plano Superior
Line(5) = {5, 6}; Line(6) = {6, 8}; Line(7) = {8, 7}; Line(8) = {7, 5};
Curve Loop(2) = {8, 5, 6, 7}; Plane Surface(2) = {2};

lineasHorizontales1[] = {2,4,6,8};
lineasHorizontales2[] = {1,3,5,7};

// --> Planos Verticales
Line(9) = {1, 5}; Line(10) = {2, 6}; Line(11) = {4, 8}; Line(12) = {3, 7};
//+
Curve Loop(3) = {9, 5, -10, -1}; Plane Surface(3) = {3};
//+
Curve Loop(4) = {10, 6, -11, -2}; Plane Surface(4) = {4};
//+
Curve Loop(5) = {11, 7, -12, -3}; Plane Surface(5) = {5};
//+
Curve Loop(6) = {8, -9, -4, 12}; Plane Surface(6) = {6};

lineasVerticales[] = {9:12};


// --> Mallado 2D


	cells = (164/1000)/deltaMax+1;
	Transfinite Curve {lineasHorizontales1[]} = cells Using Progression 1;

	cells = (310/1000)/deltaMax+1;
	Transfinite Curve {lineasHorizontales2[]} = cells Using Progression 1;

	cells = (236/1000)/deltaMax+1;
	Transfinite Curve {lineasVerticales[]} = cells Using Progression 1;
	Transfinite Surface "*";
	Recombine Surface "*"; 


// --> Mallado 3D
	Surface Loop(1) = {6, 2, 3, 4, 5, 1}; Volume(1) = {1};
	Transfinite Volume "*";
	Recombine Volume "*"; 


// --------------------- Zona Placas (Lamelas) --------------------- //

// --> Mallado 3D

	incX = 137/1000;
	incZ = 247.3/1000;
	L = Sqrt(incX^2 + incZ^2);
	cells = L/deltaMax;
	Extrude {incX, 0, incZ} { Surface{2}; Layers{cells}; Recombine;}

	Z = 488.3/1000;
	planoVertederos[] = Surface In BoundingBox {-1e9, -1e-9, Z-1e-6, 1e9, 1e9, Z+1e-6};

	alturaAgua = 591/1000-66/1000;
	incZ = alturaAgua-Z;
	cells = incZ/deltaMax;
	Extrude {0, 0, incZ} { Surface{planoVertederos[]}; Layers{cells}; Recombine;}


// ----- Volumen + Contornos ----- //
	allVomumens[] = Volume "*";
	Physical Volume("internalMesh") = {allVomumens[]};

	H = alturaAgua; //0.525;
	topSurfaces[] = Surface In BoundingBox {-1e9,-1e9,H-2e-6, 1e9,1e9,H+2e-6};	
	Physical Surface("top") = {topSurfaces[]};
	Physical Surface("bottom") = {1};
	Physical Surface("upWalls") = {6, 7, 12};	
	Physical Surface("downWalls") = {9, 14, 4};
	Physical Surface("walls") = {8, 13, 3};
	Physical Surface("half") = {10, 15, 5};
