#!/usr/bin/env bash

# -> Modulo de OpenFOAM2312
#source /Volumes/OpenFOAM-v2312/etc/bashrc

# Elimina la malla existente
foamCleanPolyMesh

# Exporta la malla de Gmsh a FOAM
gmshToFoam modBase_lamellaSettler.msh

# Refinar y resolver mallado
topoSet -dict system/topoSetDict_N1
refineMesh -dict system/refineDict_N1 -overwrite
# refineMesh -dict system/refineDict_inletN1 -overwrite
# refineMesh -dict system/refineDict_outletN1 -overwrite

topoSet -dict system/topoSetDict_N2
refineMesh -dict system/refineDict_N2 -overwrite
# refineMesh -dict system/refineDict_inletN2 -overwrite
# refineMesh -dict system/refineDict_outletN2 -overwrite

#topoSet -dict system/topoSetDict_N3
#refineMesh -dict system/refineDict_N3 -overwrite
#refineMesh -dict system/refineDict_inletN3 -overwrite

#refineWallLayer "upWalls" 0.5 -overwrite
#refineWallLayer "upWalls" 0.5 -overwrite

#refineWallLayer "downWalls" 0.5 -overwrite
#refineWallLayer "downWalls" 0.5 -overwrite

#refineWallLayer "bottom" 0.5 -overwrite
#refineWallLayer "bottom" 0.5 -overwrite
#refineWallLayer "bottom" 0.5 -overwrite

surfaceFeatureExtract
snappyHexMesh -overwrite


topoSet -dict system/topoSetDict_N1
refineMesh -dict system/refineDict_inletN1 -overwrite
refineMesh -dict system/refineDict_outletN1 -overwrite

topoSet -dict system/topoSetDict_N2
refineMesh -dict system/refineDict_inletN2 -overwrite
refineMesh -dict system/refineDict_outletN2 -overwrite


topoSet -dict system/topoSetDict
createPatch -dict system/createPatchDict -overwrite

# Cambiar la condición de los patch
changeDictionary -dict system/changeDictionaryDict

# Verifica la calidad de la malla
checkMesh






