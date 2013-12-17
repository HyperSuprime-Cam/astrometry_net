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
		msg "clang detected: applying clang-make-depend-bug.patch"
		patch -s -p1 < ./patches/clang/clang-make-depend-bug.patch
	fi
}

install()
{
	clean_old_install

	( INSTALL_DIR="$PREFIX" make -j$NJOBS install )

	install_ups
}
