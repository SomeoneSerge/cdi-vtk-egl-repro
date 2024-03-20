{ singularity-tools, vtk-demo-env }:

singularity-tools.buildImage {
  name = "vtk-demo";
  contents = [ vtk-demo-env ];
  diskSize = 4096;
}
