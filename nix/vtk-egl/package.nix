{
  lib,
  vtk,
  pkgs,
  glBackend ? "EGL",
}:

assert builtins.elem glBackend [
  null
  "X"
  "EGL"
  "OSMesa"
];

vtk.overrideAttrs (oldAttrs: {
  buildInputs =
    oldAttrs.buildInputs or [ ]
    ++ lib.optionals (glBackend == "OSMesa") [
      (lib.getOutput "osmesa" pkgs.mesa) # libOSMesa.so
      (lib.getDev pkgs.mesa) # osmesa.h
    ];
  cmakeFlags = oldAttrs.cmakeFlags or [ ] ++ [
    (lib.cmakeBool "VTK_USE_OFFSCREEN_EGL" (glBackend == "EGL"))
    (lib.cmakeBool "VTK_OPENGL_HAS_EGL" (glBackend == "EGL"))
    (lib.cmakeBool "VTK_OPENGL_HAS_OSMESA" (glBackend == "OSMesa"))
    (lib.cmakeBool "VTK_USE_X" (glBackend == "X"))
  ];
})
