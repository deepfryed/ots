require 'mkmf'

$CFLAGS  = %x{pkg-config --cflags glib-2.0}.strip
$LGFLAGS = %x{pkg-config --libs glib-2.0}.strip

if $CFLAGS.empty?
  warn %q{WARNING: No pkg-config found for glib-2.0, using defaults. Set GLIB_INCLUDE_DIR env to override.}
  dirs = ENV.fetch('GLIB_INCLUDE_DIR', '/usr/include/glib-2.0 /usr/lib/glib-2.0/include')
  $CFLAGS = dirs.split(/\s+/).map {|dir| "-I#{dir}"}.join(' ')
end

if $LDFLAGS.empty?
  warn %q{WARNING: No pkg-config found for glib-2.0, using defaults. Set GLIB_LIB env to override.}
  libs = ENV.fetch('GLIB_LIB', 'glib-2.0')
  $LDFLAGS = libs.split(/\s+/).map {|lib| "-l#{lib}"}.join(' ')
end

dir_config("libots", ["/usr/local", "/opt/local", "/usr"])

headers = [ 'stdio.h', 'stdlib.h', 'string.h', 'libots-1/ots/libots.h' ]
if have_header('libots-1/ots/libots.h') && have_library('ots-1', 'ots_new_article', headers)
  create_makefile 'ots'
else
  puts "Cannot find libots headers or libraries"
  exit 1
end
