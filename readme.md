# sqlite and supercollider

Uses [Yaafe](http://yaafe.github.io/Yaafe/) and native python sqlite3 bindings to build music databases.

You need to run python scripts with `./runScripts`, eg:

```sh
$ ./runScripts runFeatures db sound.wav
```

Yaafe just has certain environmental variables it needs set (don't know how python works..).

recursive submodule init is important for Yaafe deps.

# todo

- Wav file 16 bit 1 channel floats/bytes are stored as [struct pack](https://docs.python.org/3/library/struct.html) 32 bit long floats.  Need to figure out how Supercollider will read 16bit ints as floats.  or either way something is messed up trying to use half prec from struct.
