# Mod_SedimentadorConPlacas
Modelo tridimensional de un sedimentador con placas inclinadas (lamelas), con un plano de simetría en la sección central (plano XZ). La unidad CE~586 Precipitación y Floculación (GUNT), disponible en el Centro Interdisciplinario de Investigaciones del Agua y el Ambiente (CIIAAA-UNLP).

---------------------------------------------------------------------------------------------------------------------------------------
Comentarios: 

En [mallado.sh](mallado.sh) están los pasos que utilicé para resolver la malla 3D. Gmsh para generar la malla base con la estructura 3D del sedimentador [modBase_lamellaSettler.geo](modBase_lamellaSettler.geo). Luego utilizo topoSet, refineMesh y snappyHexMesh para refinar y resolver la malla en la zona de las placas inclinadas. El archivo del sólido de las placas es [placaScale_v4.stl](sys_v0/constant/triSurface/placaScale_v4.stl). 

Las placas están desplazadas unos 18.9 mm por lo que pude calcular según el nuevo plano. Puede utilizar surfaceTransportPoint para desplazarlo esa distancia en dirección X. 
