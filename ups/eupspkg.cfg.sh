# EupsPkg config file. Sourced by 'eupspkg'

export CFLAGS="$CFLAGS -std=gnu89"		# Set C dialect to gnu89, or clang builds will fail
export ARCH_FLAGS="-mtune=generic"		# Override machine-specific code generation

NJOBS=1						# a.d.n Makefiles hate parallelism

TAP_TAR_OPTIONS="--exclude ups"			# a.d.n tarballs contain ups/, which we'll ignore

prep()
{
	# Apply the standard patches
	default_prep

	# Apply the extra patches if building with clang
	detect_compiler
	if [[ $COMPILER_TYPE == clang ]]; then
		msg "no clang patches detected"
	fi
}

build()
{
	make -j$NJOBS SYSTEM_GSL=yes GSL_INC="-I${GSL_DIR}/include" GSL_LIB="-L${GSL_DIR}/lib -lgsl -lgslcblas" WCSLIB_INC="-I${WCSLIB_DIR}/include/wcslib" WCSLIB_LIB="-L${WCSLIB_DIR}/lib -lwcs" CFITS_INC="-I${CFITSIO_DIR}/include" CFITS_LIB="-L${CFITSIO_DIR}/lib -lcfitsio"
}

install()
{
	clean_old_install

	( INSTALL_DIR="$PREFIX" make -j$NJOBS install SYSTEM_GSL=yes GSL_INC="-I${GSL_DIR}/include" GSL_LIB="-L${GSL_DIR}/lib -lgsl -lgslcblas" WCSLIB_INC="-I${WCSLIB_DIR}/include/wcslib" WCSLIB_LIB="-L${WCSLIB_DIR}/lib -lwcs" CFITS_INC="-I${CFITSIO_DIR}/include" CFITS_LIB="-L${CFITSIO_DIR}/lib -lcfitsio" )

	install_ups
}
