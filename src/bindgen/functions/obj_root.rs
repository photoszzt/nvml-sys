// This file is part of nvml-sys. It is subject to the license terms in the COPYRIGHT file found in the top-level directory of this distribution and at https://raw.githubusercontent.com/lemonrock/nvml-sys/master/COPYRIGHT. No part of nvml-sys, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the COPYRIGHT file.
// Copyright © 2016 The developers of nvml-sys. See the COPYRIGHT file in the top-level directory of this distribution and at https://raw.githubusercontent.com/lemonrock/nvml-sys/master/COPYRIGHT.

extern "C"
{
	pub fn pmemobj_root(pop: *mut PMEMobjpool, size: usize) -> PMEMoid;
	pub fn pmemobj_root_construct(pop: *mut PMEMobjpool, size: usize, constructor: pmemobj_constr, arg: *mut c_void) -> PMEMoid;
	pub fn pmemobj_root_size(pop: *mut PMEMobjpool) -> usize;
}
