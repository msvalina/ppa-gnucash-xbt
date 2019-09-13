#!/bin/bash
# Download latest gnucash tarball
# Build container and run it
# Build ubuntu package and sign it
# Publish package on my GnuCash BTC ppa

set -xve

gc_ver=${gc_ver:-3.7}
gc_ver_ppa="${gc_ver}+bionic~ppa2"
source="https://github.com/Gnucash/gnucash/releases/download/3.7/gnucash-3.7.tar.bz2"
sha256_sum="6b8eb09f3980531509bcb3a589ab0334d827c32f860ce8a209aa2fe0ed8858b4"

repo_dir="$(pwd)"
ppa_builddir="${repo_dir}/ppa_builddir"
echo "Cleaning PPA build dir"
rm -rf "${ppa_builddir}"
mkdir -p "${ppa_builddir}"

cd "${ppa_builddir}"

gc_sourcedir="${ppa_builddir}/gnucash-${gc_ver_ppa}"
echo "Building GnuCash version: $gc_ver"
gc_tar="gnucash_${gc_ver_ppa}.orig.tar.bz2"

if [ ! -f "${gc_tar}" ]; then
    curl --location "${source}" --output "${gc_tar}"
fi
if [ "${sha256_sum}" != "$(sha256sum "${gc_tar}" | cut -d " " -f1)" ]; then
    echo "Checksum failed"; exit 1
fi
tar -xf "${gc_tar}" 
mv "gnucash-${gc_ver}" "${gc_sourcedir}"

cp -vr ../debian "${gc_sourcedir}"

cd "${gc_sourcedir}"
echo "Applying xbt.patch using quilt"
export QUILT_PATCHES="debian/patches" \
    QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index" \
    QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"

quilt push -a

# Make changelog
export DEBFULLNAME="${DEBFULLNAME:-"Marijan Svalina"}" \
    DEBEMAIL="${DEBEMAIL:-"marijan.svalina@gmail.com"}"

dch --changelog debian/changelog \
    --newversion "1:${gc_ver_ppa}" \
    --distribution bionic "Apply xbt.patch" 

echo "Starting package build"
dpkg-buildpackage --build=source \
    --source-option="-sk ${gc_tar}"  \
    --sign-command=gpg \
    --sign-key=marijan.svalina@gmail.com

cd "${ppa_builddir}"
export USER=msvalina
dput ppa:msvalina/gnucash ./gnucash_"${gc_ver_ppa}"_source.changes

