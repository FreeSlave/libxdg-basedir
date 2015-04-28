module deimos.basedir.basedir;

struct xdgHandle {
    void *reserved;
};

extern(C) @system @nogc nothrow {
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

version(BasedirMainTest)
{
    import std.stdio;
    import std.string : fromStringz;
    import std.process : environment;
    
    void printDirectories(string message, const(char*)* directories)
    {
        writef("%s: ", message);
        for (; *directories != null; directories++) {
            writef("%s;", (*directories).fromStringz);
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
        
        writeln("xdgDataHome: ", xdgDataHome(&handle).fromStringz);
        writeln("xdgConfigHome: ", xdgConfigHome(&handle).fromStringz);
        
        printDirectories("Data dirs", xdgDataDirectories(&handle));
        printDirectories("Searchable data dirs", xdgSearchableDataDirectories(&handle));
        
        printDirectories("Config dirs", xdgConfigDirectories(&handle));
        printDirectories("Searchable config dirs", xdgSearchableConfigDirectories(&handle));
        
        writeln("xdgCacheHome", xdgCacheHome(&handle).fromStringz);
        writeln("xdgRuntimeDirectory", xdgRuntimeDirectory(&handle).fromStringz);
        
        environment["XDG_CONFIG_HOME"] = "config directory updated via environment";
        if (!xdgUpdateData(&handle)) {
            stderr.writeln("Could not update handle");
        }
        writeln("xdgConfigHome after update: ", xdgConfigHome(&handle).fromStringz);
        
        return 0;
    }
}
