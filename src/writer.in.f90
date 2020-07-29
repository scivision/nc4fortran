submodule (nc4fortran:write) writer
!! This submodule is for writing 0-D..7-D data

implicit none (type, external)

contains

module procedure nc_write_scalar
integer :: varid, ier

if(.not.self%is_open) error stop 'ERROR:nc4fortran:writer: file handle not open'

select type (value)
type is (real(real64))
  ier = nf90_def_var(self%ncid, dname, NF90_DOUBLE, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (real(real32))
  ier = nf90_def_var(self%ncid, dname, NF90_FLOAT, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int32))
  ier = nf90_def_var(self%ncid, dname, NF90_INT, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
type is (integer(int64))
  ier = nf90_def_var(self%ncid, dname, NF90_INT64, varid=varid)
  if(ier == NF90_NOERR) ier = nf90_put_var(self%ncid, varid, value)
class default
  ier = NF90_EBADTYPE
end select

if (present(ierr)) ierr = ier
if (check_error(ier, dname)) then
  if (present(ierr)) return
  error stop
endif

end procedure nc_write_scalar


module procedure nc_write_1d
@writer_template@
end procedure nc_write_1d


module procedure nc_write_2d
@writer_template@
end procedure nc_write_2d


module procedure nc_write_3d
@writer_template@
end procedure nc_write_3d


module procedure nc_write_4d
@writer_template@
end procedure nc_write_4d


module procedure nc_write_5d
@writer_template@
end procedure nc_write_5d


module procedure nc_write_6d
@writer_template@
end procedure nc_write_6d


module procedure nc_write_7d
@writer_template@
end procedure nc_write_7d


end submodule writer