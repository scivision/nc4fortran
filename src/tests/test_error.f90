program test_errors
use, intrinsic:: iso_fortran_env, only: int64, int32, real32, real64, stderr=>error_unit
use nc4fortran, only: netcdf_file, NF90_NOERR

implicit none (type, external)

call test_nonexist_old_file()
print *, 'OK: non-existing old file'
call test_nonexist_unknown_file()
print *, 'OK: non-existing unknown file'
call test_nonnetcdf_file()
print *, 'OK: non-NetCDF file'
call test_nonexist_variable()
print *, 'OK: non-existing variable'
call test_wrong_type()
print *, "OK: wrong type read"
call test_unknown_read()
print *, 'OK: unknown read'

contains


subroutine test_nonexist_old_file()
integer :: ierr
type(netcdf_file) :: h

call h%open('not-exist.nc', ierr, action='r')
if (ierr==NF90_NOERR) error stop 'should have had ierr/=0 on non-existing old file'
end subroutine test_nonexist_old_file


subroutine test_nonexist_unknown_file()
integer :: ierr
type(netcdf_file) :: h

call h%open('not-exist.nc', ierr, action='r')
if (ierr==NF90_NOERR) error stop 'should have had ierr/=0 on non-existing unknown read file'
end subroutine test_nonexist_unknown_file


subroutine test_nonnetcdf_file()
integer :: u,ierr
type(netcdf_file) :: h
character(*), parameter :: filename = 'bad.nc'

! create or replace zero-length file, could be any size, just not a valid NetCDF file
open(newunit=u, file=filename, status='replace', action='write')
close(u)

call h%open(filename, ierr, action='r')
if (ierr==NF90_NOERR) error stop 'should have had ierr/=0 on invalid NetCDF file'
end subroutine test_nonnetcdf_file


subroutine test_nonexist_variable()
integer :: u,ierr
type(netcdf_file) :: h
character(*), parameter :: filename = 'bad.nc'

call h%open(filename, action='rw')
call h%read('/not-exist', u, ierr)
if (ierr==NF90_NOERR) error stop 'test_nonexist_variable: should have ierr/=0 on non-exist variable'
call h%close()
end subroutine test_nonexist_variable


subroutine test_wrong_type()
integer :: u
type(netcdf_file) :: h
character(*), parameter :: filename = 'bad.nc'

call h%open(filename, action='w')
call h%write('real32', 42.)
call h%close()

call h%open(filename, action='r')
call h%read('real32', u)
if (u /= 42) error stop 'test_wrong_type: did not coerce real to integer'
call h%close()

end subroutine test_wrong_type


subroutine test_unknown_read()
integer :: ierr
type(netcdf_file) :: h
character(*), parameter :: filename = 'bad.nc'
complex :: x

x = (1, -1)

call h%open(filename, action='r')
call h%read('/complex', x, ierr)
if(ierr==NF90_NOERR) error stop 'test_unknown_read: reading unknown type variable'
end subroutine test_unknown_read

end program
