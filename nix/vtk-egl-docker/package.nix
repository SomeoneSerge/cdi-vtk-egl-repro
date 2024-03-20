{ dockerTools, vtk-demo-env }:

dockerTools.buildLayeredImage {
  name = "vtk-demo";
  tag = "latest";
  contents = [ vtk-demo-env ];
}
