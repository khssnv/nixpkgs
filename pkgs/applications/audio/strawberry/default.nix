{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, cmake
, pkgconfig
, alsaLib
, boost
, chromaprint
, fftw
, gnutls
, libcdio
, libmtp
, libpthreadstubs
, libtasn1
, libXdmcp
, ninja
, pcre
, protobuf
, sqlite
, taglib
, libpulseaudio ? null
, libselinux ? null
, libsepol ? null
, p11-kit ? null
, utillinux ? null
, qtbase
, qtx11extras
, qttools
, withGstreamer ? true
, gst_all_1 ? null
, withVlc ? true
, libvlc ? null
}:

mkDerivation rec {
  pname = "strawberry";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "jonaski";
    repo = pname;
    rev = version;
    sha256 = "0v3rbpaz6pqkam0cj86ydq8gc2rhas8mhwgvy31djvxng9nv3h5j";
  };

  buildInputs = [
    alsaLib
    boost
    chromaprint
    fftw
    gnutls
    libcdio
    libmtp
    libpthreadstubs
    libtasn1
    libXdmcp
    pcre
    protobuf
    sqlite
    taglib
    qtbase
    qtx11extras
  ]
  ++ lib.optionals stdenv.isLinux [
    libpulseaudio
    libselinux
    libsepol
    p11-kit
    utillinux
  ]
  ++ lib.optionals withGstreamer (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ])
  ++ lib.optional withVlc libvlc;

  nativeBuildInputs = [ cmake ninja pkgconfig qttools ];

  cmakeFlags = [
    "-DUSE_SYSTEM_TAGLIB=ON"
  ];

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Music player and music collection organizer";
    homepage = "https://www.strawberrymusicplayer.org/";
    changelog = "https://raw.githubusercontent.com/jonaski/strawberry/${version}/Changelog";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    # upstream says darwin should work but they lack maintainers as of 0.6.6
    platforms = platforms.linux;
  };
}
