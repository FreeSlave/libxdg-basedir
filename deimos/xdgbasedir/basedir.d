module deimos.xdgbasedir.xdgbasedir;

package {
    static if( __VERSION__ < 2066 ) enum nogc = 1;
}

struct xdgHandle {
    void *reserved;
};

extern(C) @nogc @system nothrow {
    xdgHandle * xdgInitHandle(xdgHandle *handle);

    void xdgWipeHandle(xdgHandle *handle);
    int xdgUpdateData(xdgHandle *handle);
    const(char)* xdgDataHome(xdgHandle *handle);
    const(char)* xdgConfigHome(xdgHandle *handle);

    const(char*)* xdgDataDirectories(xdgHandle *handle);
    const(char*)* xdgSearchableDataDirectories(xdgHandle *handle);
    const(char*)* xdgConfigDirectories(xdgHandle *handle);
    const(char*)* xdgSearchableConfigDirectories(xdgHandle *handle);
    const(char)* xdgCacheHome(xdgHandle *handle);
    const(char)* xdgRuntimeDirectory(xdgHandle *handle);
}

version(XDGBasedirMainTest)
{
    import std.stdio;
    import std.process : environment;
    import std.c.string : strlen;
    
    @system pure inout(char)[] fromCString(inout(char)* cString) {
        return cString ? cString[0..strlen(cString)] : null;
    }
    
    void printDirectories(string message, const(char*)* directories)
    {
        writef("%s: ", message);
        for (; *directories != null; directories++) {
            writef("%s;", (*directories)[0..strlen(*directories)]);
        }
        writeln();
    }
    
    int main(string[] args) 
    {
        xdgHandle handle;
        if (!xdgInitHandle(&handle)) {
            stderr.writeln("Could not initialize xdgHandle");
            return -1;
        }
        scope(exit) xdgWipeHandle(&handle);
        
        writeln("xdgDataHome: ", xdgDataHome(&handle).fromCString);
        writeln("xdgConfigHome: ", xdgConfigHome(&handle).fromCString);
        
        printDirectories("Data dirs", xdgDataDirectories(&handle));
        printDirectories("Searchable data dirs", xdgSearchableDataDirectories(&handle));
        
        printDirectories("Config dirs", xdgConfigDirectories(&handle));
        printDirectories("Searchable config dirs", xdgSearchableConfigDirectories(&handle));
        
        writeln("xdgCacheHome: ", xdgCacheHome(&handle).fromCString);
        writeln("xdgRuntimeDirectory: ", xdgRuntimeDirectory(&handle).fromCString);
        
        environment["XDG_CONFIG_HOME"] = "config directory updated via environment";
        if (!xdgUpdateData(&handle)) {
            stderr.writeln("Could not update handle");
        }
        writeln("xdgConfigHome after update: ", xdgConfigHome(&handle).fromCString);
        
        return 0;
    }
}
