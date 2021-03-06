{ stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "0.5";

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "3be13f40c02f245ac03a8b3500736e657f04920a";
    sha256 = "09q33iw0y5xb2237k0px5s54kbk0ch20nr4j2c050nzss3fmsg2f";
  };

  separateDebugInfo = true;
  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  configurePhase = ''
    ./configure \
      --prefix=$out \
      --includedir=$dev/include \
      --libdir=$lib/lib \
      --libdevdir=$lib/lib \
      --mandir=$man/share/man \
  '';

  # Copy the examples into $out.
  postInstall = ''
    mkdir -p $out/bin
    cp ./examples/io_uring-cp examples/io_uring-test $out/bin
    cp ./examples/link-cp $out/bin/io_uring-link-cp
    cp ./examples/ucontext-cp $out/bin/io_uring-ucontext-cp
  '';

  meta = with stdenv.lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = https://git.kernel.dk/cgit/liburing/;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
