require 'mkmf'

glib_cflags   = %x{pkg-config --cflags  glib-2.0}.strip
glib_ldflags  = %x{pkg-config --libs    glib-2.0}.strip

if glib_cflags.empty?
  warn %q{WARNING: No pkg-config found for glib-2.0, using defaults. Set GLIB_INCLUDE_DIR env to override.}
  dirs = ENV.fetch('GLIB_INCLUDE_DIR', '/usr/include/glib-2.0 /usr/lib/glib-2.0/include')
  glib_cflags = dirs.split(/\s+/).map {|dir| "-I#{dir}"}.join(' ')
end

if glib_ldflags.empty?
  warn %q{WARNING: No pkg-config found for glib-2.0, using defaults. Set GLIB_LIB env to override.}
  libs = ENV.fetch('GLIB_LIB', 'glib-2.0')
  glib_ldflags = libs.split(/\s+/).map {|lib| "-l#{lib}"}.join(' ')
end

dir      = File.expand_path(File.dirname(__FILE__) + '/../dictionaries')
$CFLAGS  = glib_cflags + %Q{ -I/usr/include/libxml2 -DDICTIONARY_DIR='"#{dir}/"'}
$LDFLAGS = glib_ldflags

find_library('glib-2.0', 'main')
find_library('xml2',     'main')

create_makefile 'ots'
