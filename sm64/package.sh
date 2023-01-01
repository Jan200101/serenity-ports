#!/usr/bin/env -S bash ../.port_include.sh
port='sm64'
version='0.0.0'
commit_hash='ec9227a3d52a8d23c7e7c5d0d972168dcd93acfd'
useconfigure='true'
makeopts+=(
    'RENDER_API=GL_LEGACY'
    'DEBUG=1'
)
depends=('SDL2' 'bla')
files="https://github.com/Jan200101/sm64ex/archive/${commit_hash}.tar.gz sm64-${commit_hash}.tar.gz"
workdir="sm64ex-${commit_hash}"
baserom="baserom.us.z64"

configure() {
    # detect required files we cannot distribute
    if [ ! -f "${PORT_BUILD_DIR}/${workdir}/${baserom}" ]; then
        if [ ! -f "${PORT_META_DIR}/${baserom}" ]; then
            echo "Error: $baserom could not be found"
            exit 1
        else
            run cp "${PORT_META_DIR}/$baserom" "${PORT_BUILD_DIR}/${workdir}/$baserom"
        fi
    fi
}

build() {

    echo $SCRIPT

    host_env
    run sh -c "cd tools && make ${makeopts[@]}"

    target_env
    run make "${makeopts[@]}"
}
install() {
    run cp build/us_pc/sm64.us.f3dex2e "${SERENITY_BUILD_DIR}/Root/usr/local/bin/sm64"
}
