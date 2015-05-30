module deimos.xdgbasedir.xdgbasedir_fs;

import deimos.xdgbasedir.xdgbasedir;
import std.c.stdio : FILE;
import core.sys.posix.sys.types : mode_t;

extern(C) @nogc @system nothrow {
    char * xdgDataFind(const(char)* relativePath, xdgHandle *handle);
    char * xdgConfigFind(const char* relativePath, xdgHandle *handle);
    FILE * xdgDataOpen(const(char)* relativePath, const(char)* mode, xdgHandle *handle);
    FILE * xdgConfigOpen(const(char)* relativePath, const(char)* mode, xdgHandle *handle);
    int xdgMakePath(const(char)* path, mode_t mode);
}


version(XDGBasedirFSMainTest)
{
    import std.stdio;
    import std.c.string : strlen;
    import std.c.stdlib : free;
    
    void printPaths(string message, char* paths)
    {
        writef("%s: ", message);
        for (; paths[0] != '\0'; paths += strlen(paths) + 1)
        {
            writef("%s;", paths[0..strlen(paths)]);
        }
        writeln();
    }
    
    int main(string[] args)
    {
        xdgHandle handle;
        if (!xdgInitHandle(&handle)) {
            stderr.writeln("Could not initilaze xdgHandle");
            return -1;
        }
        scope(exit) xdgWipeHandle(&handle);
        
        auto autostartPaths = xdgConfigFind("autostart", &handle);
        scope(exit) free(autostartPaths);
        printPaths("Autostart path", autostartPaths);
        
        auto applicationsPath = xdgDataFind("applications", &handle);
        scope(exit) free(applicationsPath);
        printPaths("Applications path", applicationsPath);
        return 0;
    }
}
