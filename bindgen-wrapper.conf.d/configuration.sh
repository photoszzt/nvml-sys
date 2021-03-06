# This file is part of nvml-sys. It is subject to the license terms in the COPYRIGHT file found in the top-level directory of this distribution and at https://raw.githubusercontent.com/lemonrock/nvml-sys/master/COPYRIGHT. No part of nvml-sys, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the COPYRIGHT file.
# Copyright © 2016 The developers of nvml-sys. See the COPYRIGHT file in the top-level directory of this distribution and at https://raw.githubusercontent.com/lemonrock/nvml-sys/master/COPYRIGHT.


bindingsName='pmdk'
rootIncludeFileName='pmdk.h'
macosXHomebrewPackageNames=''
alpineLinuxPackageNames='rsync make gcc linux-headers libunwind-dev linux-grsec-dev'
clangAdditionalArguments='-DPMEMOBJ_DIRECT_NON_INLINE -target x86_64-pc-linux-musl'
headersFolderPath='usr/include'
libFolderPath='usr/lib'
link='pmdk'
link_kind='static-nobundle'

final_chance_to_tweak()
{
	sed -i \
		-e 's/\*mut __jmp_buf_tag/jmp_buf/g' \
		"$outputFolderPath"/functions/obj_tx.rs \
		"$outputFolderPath"/functions/setjmp.rs

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/POBJ_FLAG.rs
	cat >>"$outputFolderPath"/constants/POBJ_FLAG.rs <<-EOF
		const POBJ_FLAG_ZERO: u64 = 1 << 0;
		const POBJ_FLAG_NO_FLUSH: u64 = 1 << 0;
	EOF

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/POBJ_XALLOC.rs
	cat >>"$outputFolderPath"/constants/POBJ_XALLOC.rs <<-EOF
		pub const POBJ_XALLOC_ZERO: u64 = POBJ_FLAG_ZERO;
		pub const POBJ_XALLOC_NO_FLUSH: u64 = POBJ_FLAG_NO_FLUSH;
		pub const POBJ_XALLOC_VALID_FLAGS: u64 = (POBJ_XALLOC_ZERO | POBJ_XALLOC_NO_FLUSH);
	EOF

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/POBJ_XADD.rs
	cat >>"$outputFolderPath"/constants/POBJ_XADD.rs <<-EOF
		pub const POBJ_XADD_NO_FLUSH: u64 = POBJ_FLAG_NO_FLUSH;
		pub const POBJ_XADD_VALID_FLAGS: u64 = POBJ_XADD_NO_FLUSH;
	EOF

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/PMEMOBJ_MAX.rs
	cat >>"$outputFolderPath"/constants/PMEMOBJ_MAX.rs <<-EOF
		pub const PMEMOBJ_MAX_ALLOC_SIZE: size_t = 0x3FFDFFFC0;
		pub const PMEMOBJ_MAX_LAYOUT: size_t = 1024;
	EOF

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/TX_DEFAULT.rs
	cat >>"$outputFolderPath"/constants/TX_DEFAULT.rs <<-EOF
		// Accurate as of May 7th 2017
		// src/libpmemobj/tx.c
		pub const TX_DEFAULT_RANGE_CACHE_SIZE: c_longlong = 1 << 15;

		// Accurate as of May 7th 2017
		// src/libpmemobj/tx.c
		pub const TX_DEFAULT_RANGE_CACHE_THRESHOLD: c_longlong = 1 << 12;
	EOF

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/PMEMBLK_MIN.rs
	cat >>"$outputFolderPath"/constants/PMEMBLK_MIN.rs <<-EOF
		// Accurate as of May 7th 2017
		pub const PMEMBLK_MIN_BLK: size_t = 512;

		// Accurate as of May 7th 2017
		// 16MB + 4KB (minimum BTT size + mmap alignment)
		#[cfg(unix)] pub const PMEMBLK_MIN_POOL: size_t = (1 << 20) * 16 + (1 << 10) * 8;

		// Accurate as of May 7th 2017
		// 16MB + 64KB (minimum BTT size + mmap alignment)
		#[cfg(windows)] pub const PMEMBLK_MIN_POOL: size_t = (1 << 20) * 16 + (1 << 10) * 64;
	EOF

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/PMEMOBJ_MIN.rs
	cat >>"$outputFolderPath"/constants/PMEMOBJ_MIN.rs <<-EOF
		// Accurate as of May 7th 2017
		pub const PMEMOBJ_MIN_POOL: size_t = 1024 * 1024 * 8;
	EOF

	cat "$configurationFolderPath"/preamble.rs >"$outputFolderPath"/constants/PMEMLOG_MIN.rs
	cat >>"$outputFolderPath"/constants/PMEMLOG_MIN.rs <<-EOF
		// Accurate as of May 7th 2017
		pub const PMEMLOG_MIN_POOL: size_t = 1024 * 1024 * 2;
	EOF

	cat >>"$outputFolderPath"/constants/PMEMCTO.rs <<-EOF

		// Accurate as of Jan 4th 2017
		pub const PMEMCTO_MIN_POOL: size_t = 1024 * 1024 * 16;

		// Accurate as of Jan 4th 2017
		pub const PMEMCTO_MIN_PART: size_t = 1024 * 1024 * 2;

		// Accurate as of Jan 4th 2017
		pub const PMEMCTO_MAX_LAYOUT: size_t = 1024;
	EOF

	cat >>"$outputFolderPath"/constants.rs <<-EOF
		include!("constants/POBJ_FLAG.rs");
		include!("constants/POBJ_XALLOC.rs");
		include!("constants/POBJ_XADD.rs");
		include!("constants/PMEMOBJ_MAX.rs");
		include!("constants/TX_DEFAULT.rs");
		include!("constants/PMEMBLK_MIN.rs");
		include!("constants/PMEMOBJ_MIN.rs");
		include!("constants/PMEMLOG_MIN.rs");
	EOF

	# As of bindgen 0.33.1, #[derive(Copy, Clone)] doesn't seem to always be derived.
	local derive_copy_and_clone
	for derive_copy_and_clone in \
		'__jmp_buf_tag' \
		'pmemoid'
	do
		sed -i -e "s/pub struct ${derive_copy_and_clone}/#[derive(Copy, Clone)]\npub struct ${derive_copy_and_clone}/g" "$outputFolderPath"/structs/"$derive_copy_and_clone".rs
	done
}
