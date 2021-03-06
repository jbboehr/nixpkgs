{ stdenv, fetchFromGitHub, icmake
, libmilter, libX11, openssl, readline
, utillinux, yodl }:

stdenv.mkDerivation rec {
  name = "bobcat-${version}";
  version = "4.07.00";

  src = fetchFromGitHub {
    sha256 = "0ja6rgdw4ng10acp2c0cv9k72i5sgng03i3xi2yshlm2811lgxcs";
    rev = version;
    repo = "bobcat";
    owner = "fbb-git";
  };

  buildInputs = [ libmilter libX11 openssl readline utillinux ];
  nativeBuildInputs = [ icmake yodl ];

  setSourceRoot = ''
    sourceRoot=$(echo */bobcat)
  '';

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
  '';

  buildPhase = ''
    ./build libraries all
    ./build man
  '';

  installPhase = ''
    ./build install x
  '';

  meta = with stdenv.lib; {
    description = "Brokken's Own Base Classes And Templates";
    homepage = https://fbb-git.github.io/bobcat/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
