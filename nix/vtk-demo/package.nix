{ writers, vtk-egl, vtk-demo-name ? "vtk-demo" }:

writers.writePython3Bin vtk-demo-name {
  libraries = [ vtk-egl ];
  flakeIgnore = [
    "E265"
    "F401"
  ];
} (builtins.readFile ./main.py)
