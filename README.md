
# libxdg-basedir

[libxdg-basedir](https://github.com/devnev/libxdg-basedir) is an implementation of the XDG Base Directory specifications.
This repository provides D binding to this library.

## Usage

Add the library as dependency to your dub.json. Use *dub add-local* to add path to the library.
Another option is just include **deimos** folder and its contents to your project. Don't forget to link to libxdg-basedir.

## Examples

Run:

    dub run xdg-basedir:basedir    
    dub run xdg-basedir:basedir_fs

You can find the source code of examples in deimos/basedir/basedir.d and deimos/basedir/basedir_fs.d files.
