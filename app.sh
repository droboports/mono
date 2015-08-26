### ZLIB ###
_build_zlib() {
local VERSION="1.2.8"
local FOLDER="zlib-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://zlib.net/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --prefix="${DEPS}" --libdir="${DEST}/lib" --shared
make
make install
popd
}

### MCS ###
_build_mcs() {
if [ ! -f /usr/bin/mcs ]; then
  sudo apt-get install mono-mcs
fi
}

### MONO NATIVE ###
_build_mono_native() {
local VERSION="4.0.4"
local FOLDER="mono-${VERSION}"
local FILE="${FOLDER}.1.tar.bz2"
local URL="http://download.mono-project.com/sources/mono/${FILE}"

#local MONOLITE_TGZ="monolite-117-latest.tar.gz"
#local MONOLITE_URL="http://storage.bos.xamarin.com/mono-dist-master/latest/${MONOLITE_TGZ}"
# _download_file "${MONOLITE_TGZ}" "${MONOLITE_URL}"
# tar zxf "download/${MONOLITE_TGZ}" -C "target/${FOLDER}/mcs/class/lib"
# pushd "target/${FOLDER}/mcs/class/lib"
# mv -vf monolite-* monolite
# popd

_download_bz2 "${FILE}" "${URL}" "${FOLDER}"
mv -vf "target/${FOLDER}" "target/${FOLDER}-native"
( . uncrosscompile.sh
  pushd "target/${FOLDER}-native"
  ./configure --prefix="${DEST}" --mandir="${DEST}/man"
  make 
  make install )
}

### MONO ###
_build_mono() {
local VERSION="4.0.4"
local FOLDER="mono-${VERSION}"
local FILE="${FOLDER}.1.tar.bz2"
local URL="http://download.mono-project.com/sources/mono/${FILE}"

_download_bz2 "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEST}" --mandir="${DEST}/man" \
  --with-crosspkgdir="${DEST}/lib/pkgconfig" \
  --disable-mcs-build
make
make install
popd
}

### BUILD ###
_build() {
  _build_zlib
  _build_mono_native
  _build_mono
  _package
}
