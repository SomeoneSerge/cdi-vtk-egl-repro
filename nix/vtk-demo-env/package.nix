{
  buildEnv,
  vtk-demo,
  vtk-egl,
  glibc,
  bashInteractive,
  coreutils,
}:

buildEnv {
  name = "vtk-demo";
  paths = [
    (vtk-demo.override {
      vtk-demo-name = "vtk-demo-egl";
      vtk-egl = vtk-egl.override { glBackend = "EGL"; };
    })
    # (vtk-demo.override {
    #   vtk-demo-name = "vtk-demo-osmesa";
    #   vtk-egl = vtk-egl.override { glBackend = "OSMesa"; };
    # })
    (vtk-demo.override {
      vtk-demo-name = "vtk-demo-x";
      vtk-egl = vtk-egl.override { glBackend = "X"; };
    })
    bashInteractive
    coreutils
    glibc.bin
  ];
}
