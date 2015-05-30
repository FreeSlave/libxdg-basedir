
# libxdg-basedir

[libxdg-basedir](https://github.com/devnev/libxdg-basedir) is an implementation of the XDG Base Directory specifications.
This repository provides D binding to this library.

## Usage

Add xdg-basedir as dependency to your dub.json:

```json
"dependencies": {
    "xdg-basedir": "~master"
}
```

Don't forget to link to libxdg-basedir:

```json
"libs" : ["xdg-basedir"]
```

Import the module in your code:
    
    import deimos.xdgbasedir.basedir;
    import deimos.xdgbasedir.basedir_fs;

## Examples

Run:

    dub run xdg-basedir:basedir    
    dub run xdg-basedir:basedir_fs

You can find the source code of examples in deimos/xdgbasedir/basedir.d and deimos/xdgbasedir/basedir_fs.d files.
