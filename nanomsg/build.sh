rm -fr Packages Build Prefix

mkdir Packages
mkdir Build
mkdir Prefix

unzip Archives/nanomsg-1.0.0.zip -d Packages/
pushd Build
cmake -DNN_STATIC_LIB=ON -DCMAKE_INSTALL_PREFIX=../Prefix -G'Unix Makefiles' ../Packages/nanomsg-1.0.0
make install
popd

