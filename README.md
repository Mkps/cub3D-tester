# cub3d-tester
A Cub3d project tester for 42 School. Original script + weird/error maps @romslf. Good and bad map from @mcombeau.

# How to use ?
1. Clone this repo in the root folder of your Cub3D project. (⚠️ Don't rename the repo folder, or edit mapsPath in both `.sh`)
2. Go in the cloned folder.
3. If your makefile and cub3D executable are in the root of your project, skip this step.
    * Open test-map-errors.sh and edit  line 2 and 3, "execPath" and "makePath".
    * Do the same for all maps.
4. Run `./test-map-errors.sh`, './test-map-good.sh', './test-map-bad.sh' and `./test-map-weird.sh`
