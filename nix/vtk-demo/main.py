#!/usr/bin/env python

# https://examples.vtk.org/site/Python/IO/ImageWriter/

# noinspection PyUnresolvedReferences
import vtkmodules.vtkInteractionStyle

# noinspection PyUnresolvedReferences
import vtkmodules.vtkRenderingOpenGL2
from vtkmodules.vtkCommonColor import vtkNamedColors
from vtkmodules.vtkFiltersSources import vtkSphereSource
from vtkmodules.vtkIOImage import (
    vtkBMPWriter,
    vtkJPEGWriter,
    vtkPNGWriter,
    vtkPNMWriter,
    vtkPostScriptWriter,
    vtkTIFFWriter,
)
from vtkmodules.vtkRenderingCore import (
    vtkActor,
    vtkGraphicsFactory,
    vtkPolyDataMapper,
    vtkRenderWindow,
    vtkRenderer,
    vtkWindowToImageFilter,
)


def main():
    colors = vtkNamedColors()

    # Set the background color.
    colors.SetColor("BkgColor", [26, 51, 102, 255])

    factory = vtkGraphicsFactory()
    factory.SetOffScreenOnlyMode(1)
    factory.SetUseMesaClasses(1)

    # create source
    source = vtkSphereSource()
    source.SetCenter(0, 0, 0)
    source.SetRadius(5.0)

    # mapper
    mapper = vtkPolyDataMapper()
    mapper.SetInputConnection(source.GetOutputPort())

    # actor
    actor = vtkActor()
    actor.SetMapper(mapper)

    # color the actor
    actor.GetProperty().SetColor(colors.GetColor3d("Yellow"))

    ren = vtkRenderer()
    renWin = vtkRenderWindow()
    renWin.SetOffScreenRendering(1)
    renWin.AddRenderer(ren)

    ren.AddActor(actor)
    ren.SetBackground(colors.GetColor3d("BkgColor"))

    renWin.Render()

    # ext = ["", ".png", ".jpg", ".ps", ".tiff", ".bmp", ".pnm"]
    ext = [".png"]
    filenames = list(map(lambda x: "ImageWriter" + x, ext))
    # filenames[0] = filenames[0] + "1"
    for f in filenames:
        WriteImage(f, renWin, rgba=False)


def WriteImage(fileName, renWin, rgba=True):
    """
    Write the render window view to an image file.

    Image types supported are:
     BMP, JPEG, PNM, PNG, PostScript, TIFF.
    The default parameters are used for all writers, change as needed.

    :param fileName: The file name, if no extension then PNG is assumed.
    :param renWin: The render window.
    :param rgba: Used to set the buffer type.
    :return:
    """

    import os

    if fileName:
        # Select the writer to use.
        path, ext = os.path.splitext(fileName)
        ext = ext.lower()
        if not ext:
            ext = ".png"
            fileName = fileName + ext
        if ext == ".bmp":
            writer = vtkBMPWriter()
        elif ext == ".jpg":
            writer = vtkJPEGWriter()
        elif ext == ".pnm":
            writer = vtkPNMWriter()
        elif ext == ".ps":
            if rgba:
                rgba = False
            writer = vtkPostScriptWriter()
        elif ext == ".tiff":
            writer = vtkTIFFWriter()
        else:
            writer = vtkPNGWriter()

        windowto_image_filter = vtkWindowToImageFilter()
        windowto_image_filter.SetInput(renWin)
        windowto_image_filter.SetScale(1)  # image quality
        if rgba:
            windowto_image_filter.SetInputBufferTypeToRGBA()
        else:
            windowto_image_filter.SetInputBufferTypeToRGB()
            # Read from the front buffer.
            windowto_image_filter.ReadFrontBufferOff()
            windowto_image_filter.Update()

        writer.SetFileName(fileName)
        writer.SetInputConnection(windowto_image_filter.GetOutputPort())
        writer.Write()
    else:
        raise RuntimeError("Need a filename.")


if __name__ == "__main__":
    main()
