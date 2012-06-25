
# Speedsolving.com Logo Files

Source files for the [speedsolving.com](http://www.speedsolving.com/forum/) logo, banner, favicon, etc.

![Speedsolving.com Cube Logo](https://github.com/lgarron/speedsolving.com-logo/raw/master/img/ss_cube_100.png)

## Details

Most of of the files are written in [POV-Ray](http://www.povray.org/). I render them using [MegaPOV](http://megapov.inetart.net/) on OSX. I will not document how to use these programs; they have ample documentation.

### Logo

`logo.pov` contains the logo cube, in cubic (unturned) form. It generates an (uncropped) version of `img/ss_cube.png`.

### Banner

The banner consists of grid and a cube, assembled in [the] [GIMP](http://www.gimp.org/) with some text in order to resemble the design it was intended to replace.

- `banner_grid.pov` uses `banner_grid_colors.png` to generate the grid. This is done with a resolution of 594x96.
- `banner_cube.pov` generates a version of the logo that is slightly turned.
- `banner.xcf` contains the assembled file that is exported to the banner. (Although the version on speedsolving.com has also been run through `pngcrush`.)

### Favicon

`img/ss_icon.ico` was created from `img/ss_cube.png` using GIMP.