{ stdenv, consul, ruby_2_3, bundlerEnv, zip, v8_3_16_14 }:

let
  # `sass` et al
  gems = bundlerEnv {
    name = "consul-ui-deps";
    gemdir = ./.;
    ruby = ruby_2_3;
  };
in

stdenv.mkDerivation {
  name = "consul-ui-${consul.version}";

  src = consul.src;

  patches = [ ./ui-v8.patch ];

  buildInputs = [ ruby_2_3 gems zip v8_3_16_14 ];

  prePatch = "patchShebangs ./ui/scripts/dist.sh";

  buildPhase = ''
    # Build ui static files
    cd ui
    cat *.lock
    make dist
  '';

  installPhase = ''
    # Install ui static files
    mkdir -p $out
    mv ../pkg/web_ui/* $out
  '';

  meta = with stdenv.lib; {
    homepage    = https://www.consul.io/;
    description = "A tool for service discovery, monitoring and configuration";
    maintainers = with maintainers; [ cstrahan wkennington ];
    license     = licenses.mpl20 ;
    platforms   = platforms.unix;
  };
}
